import AppKit
import AVFoundation
import UniformTypeIdentifiers

enum MediaKind {
    case video
    case image

    static func of(_ url: URL) -> MediaKind {
        if let type = UTType(filenameExtension: url.pathExtension),
           type.conforms(to: .image) {
            return .image
        }
        return .video
    }
}

/// На какие мониторы ставить обои
enum DisplayTarget: Hashable {
    case main
    case all
    case screen(CGDirectDisplayID)

    func resolve() -> [NSScreen] {
        switch self {
        case .main:
            NSScreen.main.map { [$0] } ?? []
        case .all:
            NSScreen.screens
        case .screen(let id):
            // Если монитор отключили — откатываемся на основной
            NSScreen.screens.first { $0.displayID == id }.map { [$0] }
                ?? (NSScreen.main.map { [$0] } ?? [])
        }
    }
}

extension NSScreen {
    var displayID: CGDirectDisplayID {
        deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID ?? 0
    }
}

/// Управляет окнами-обоями: по одному безрамочному окну на каждый дисплей,
/// расположенному на уровне рабочего стола (под окнами приложений и иконками).
/// Поддерживает видео (AVPlayerLayer) и статичные картинки (CALayer contents).
final class WallpaperEngine {

    private struct Unit {
        let window: NSWindow
        let player: AVQueuePlayer?
        let playerLayer: AVPlayerLayer?
        let imageLayer: CALayer?
        let looper: AVPlayerLooper?
        let occlusionObserver: NSObjectProtocol?
    }

    private var units: [Unit] = []
    private var observers: [NSObjectProtocol] = []

    private var currentURL: URL?
    private var gravity: AVLayerVideoGravity = .resizeAspectFill

    /// Целевые мониторы; при смене надо перезапустить через start(url:)
    var target: DisplayTarget = .main

    /// Пауза, поставленная пользователем — не снимается системными событиями
    private var userPaused = false
    /// Пауза из-за блокировки/сна экрана
    private var systemPaused = false

    init() {
        let center = NotificationCenter.default
        let workspace = NSWorkspace.shared.notificationCenter
        let distributed = DistributedNotificationCenter.default()

        // Все наблюдатели используют queue: .main, поэтому assumeIsolated безопасен
        func onMain(_ handler: @escaping @MainActor () -> Void) -> @Sendable (Notification) -> Void {
            { _ in MainActor.assumeIsolated { handler() } }
        }

        // Смена конфигурации мониторов — пересоздаём окна
        observers.append(center.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil, queue: .main,
            using: onMain { [weak self] in
                guard let self, let url = self.currentURL else { return }
                self.start(url: url)
            }
        ))

        // Сон/пробуждение системы и блокировка экрана — декодировать незачем
        let pauseEvents: [(NotificationCenter, Notification.Name)] = [
            (workspace, NSWorkspace.willSleepNotification),
            (workspace, NSWorkspace.screensDidSleepNotification),
            (distributed, Notification.Name("com.apple.screenIsLocked")),
            (distributed, Notification.Name("com.apple.screensaver.didstart")),
        ]
        let resumeEvents: [(NotificationCenter, Notification.Name)] = [
            (workspace, NSWorkspace.didWakeNotification),
            (workspace, NSWorkspace.screensDidWakeNotification),
            (distributed, Notification.Name("com.apple.screenIsUnlocked")),
            (distributed, Notification.Name("com.apple.screensaver.didstop")),
        ]
        for (notificationCenter, name) in pauseEvents {
            observers.append(notificationCenter.addObserver(
                forName: name, object: nil, queue: .main,
                using: onMain { [weak self] in self?.systemPause() }
            ))
        }
        for (notificationCenter, name) in resumeEvents {
            observers.append(notificationCenter.addObserver(
                forName: name, object: nil, queue: .main,
                using: onMain { [weak self] in self?.systemResume() }
            ))
        }
    }

    var isRunning: Bool { !units.isEmpty }

    func start(url: URL) {
        stopPlayback()
        currentURL = url
        userPaused = false
        systemPaused = false

        switch MediaKind.of(url) {
        case .video:
            startVideo(url: url)
        case .image:
            startImage(url: url)
        }
    }

    func stop() {
        stopPlayback()
        currentURL = nil
    }

    func pause() {
        userPaused = true
        units.forEach { $0.player?.pause() }
    }

    func resume() {
        userPaused = false
        guard !systemPaused else { return }
        for unit in units where unit.window.occlusionState.contains(.visible) {
            unit.player?.play()
        }
    }

    func setGravity(_ gravity: AVLayerVideoGravity) {
        self.gravity = gravity
        units.forEach {
            $0.playerLayer?.videoGravity = gravity
            $0.imageLayer?.contentsGravity = Self.layerGravity(for: gravity)
        }
    }

    // MARK: - Запуск контента

    private func startVideo(url: URL) {
        for screen in target.resolve() {
            let item = AVPlayerItem(url: url)
            let player = AVQueuePlayer(playerItem: item)
            player.isMuted = true
            // Обои не должны мешать дисплею засыпать
            player.preventsDisplaySleepDuringVideoPlayback = false
            let looper = AVPlayerLooper(player: player, templateItem: item)

            let (window, contentView) = makeDesktopWindow(for: screen)

            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = contentView.bounds
            playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
            playerLayer.videoGravity = gravity
            contentView.layer?.addSublayer(playerLayer)

            let occlusionObserver = NotificationCenter.default.addObserver(
                forName: NSWindow.didChangeOcclusionStateNotification,
                object: window, queue: .main
            ) { [weak self] notification in
                nonisolated(unsafe) let object = notification.object
                MainActor.assumeIsolated {
                    guard let window = object as? NSWindow else { return }
                    self?.occlusionChanged(for: window)
                }
            }

            window.orderFront(nil)
            player.play()

            units.append(Unit(
                window: window,
                player: player,
                playerLayer: playerLayer,
                imageLayer: nil,
                looper: looper,
                occlusionObserver: occlusionObserver
            ))
        }
    }

    private func startImage(url: URL) {
        guard let image = NSImage(contentsOf: url) else { return }

        for screen in target.resolve() {
            let (window, contentView) = makeDesktopWindow(for: screen)

            let imageLayer = CALayer()
            imageLayer.frame = contentView.bounds
            imageLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
            imageLayer.contents = image
            imageLayer.contentsGravity = Self.layerGravity(for: gravity)
            contentView.layer?.addSublayer(imageLayer)

            window.orderFront(nil)

            units.append(Unit(
                window: window,
                player: nil,
                playerLayer: nil,
                imageLayer: imageLayer,
                looper: nil,
                occlusionObserver: nil
            ))
        }
    }

    // MARK: - Внутреннее

    private static func layerGravity(for gravity: AVLayerVideoGravity) -> CALayerContentsGravity {
        gravity == .resizeAspectFill ? .resizeAspectFill : .resizeAspect
    }

    private func stopPlayback() {
        units.forEach {
            if let observer = $0.occlusionObserver {
                NotificationCenter.default.removeObserver(observer)
            }
            $0.player?.pause()
            $0.player?.removeAllItems()
            $0.window.orderOut(nil)
        }
        units.removeAll()
    }

    private func systemPause() {
        systemPaused = true
        units.forEach { $0.player?.pause() }
    }

    private func systemResume() {
        systemPaused = false
        guard !userPaused else { return }
        for unit in units where unit.window.occlusionState.contains(.visible) {
            unit.player?.play()
        }
    }

    /// Пауза декодирования, когда рабочий стол полностью перекрыт окнами
    /// или fullscreen-приложением — экономит CPU/GPU.
    private func occlusionChanged(for window: NSWindow) {
        guard let unit = units.first(where: { $0.window === window }),
              let player = unit.player else { return }
        if window.occlusionState.contains(.visible) {
            if !userPaused && !systemPaused {
                player.play()
            }
        } else {
            player.pause()
        }
    }

    private func makeDesktopWindow(for screen: NSScreen) -> (NSWindow, NSView) {
        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        // Уровень рабочего стола: над системными обоями, под иконками и окнами
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        window.ignoresMouseEvents = true
        window.isReleasedWhenClosed = false
        window.backgroundColor = .black
        window.hasShadow = false

        let contentView = NSView(frame: screen.frame)
        contentView.wantsLayer = true
        window.contentView = contentView

        return (window, contentView)
    }
}
