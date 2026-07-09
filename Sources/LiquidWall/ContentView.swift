import SwiftUI
import AVFoundation
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.openWindow) private var openWindow
    @Environment(\.locale) private var locale
    @State private var thumbnail: NSImage?

    static let windowSize = CGSize(width: 980, height: 620)

    var body: some View {
        @Bindable var model = model

        HStack(spacing: 0) {
            SidebarView(thumbnail: thumbnail)
                .frame(width: 320)

            Divider()
                .opacity(0.4)

            rightPane
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(backdrop)
        .frame(width: Self.windowSize.width, height: Self.windowSize.height)
        .id(model.appLanguage)
        .sheet(item: $model.previewItem) { item in
            PreviewSheet(item: item)
        }
        .onAppear {
            // Окно точно существует при первом запуске — сохраняем способ
            // открыть его заново после закрытия (клик по иконке в доке)
            AppDelegate.openMainWindow = { openWindow(id: "main") }
            AppDelegate.openHelpWindow = { openWindow(id: "help") }
            model.restoreOnLaunch()
        }
        .task(id: model.mediaURL) {
            await loadThumbnail()
        }
    }

    @ViewBuilder
    private var rightPane: some View {
        @Bindable var model = model

        if model.pixabayKey.isEmpty {
            OnboardingView()
        } else {
            VStack(spacing: 0) {
                Picker("", selection: $model.pane) {
                    ForEach(ContentPane.allCases) { pane in
                        Text(pane.label(locale: locale)).tag(pane)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .frame(width: 260)
                .padding(.top, 14)

                switch model.pane {
                case .gallery: GalleryPane()
                case .library: LibraryPane()
                }
            }
        }
    }

    // Размытый кадр текущих обоев как фон всего окна
    private var backdrop: some View {
        ZStack {
            if let thumbnail {
                Image(nsImage: thumbnail)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 70)
                    .opacity(0.45)
            } else {
                LinearGradient(
                    colors: [.indigo.opacity(0.3), .cyan.opacity(0.15), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        .ignoresSafeArea()
    }

    private func loadThumbnail() async {
        guard let url = model.mediaURL else {
            thumbnail = nil
            return
        }
        thumbnail = await MediaThumbnailer.thumbnail(for: url)
    }
}

/// Общий генератор миниатюр для видео и картинок
enum MediaThumbnailer {
    static func thumbnail(for url: URL, maxSize: CGFloat = 800) async -> NSImage? {
        switch MediaKind.of(url) {
        case .image:
            return NSImage(contentsOf: url)
        case .video:
            let generator = AVAssetImageGenerator(asset: AVURLAsset(url: url))
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = CGSize(width: maxSize, height: maxSize)
            guard let cgImage = try? await generator
                .image(at: .init(seconds: 1, preferredTimescale: 600)).image else { return nil }
            return NSImage(cgImage: cgImage, size: .zero)
        }
    }
}

// MARK: - Сайдбар

private struct SidebarView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.locale) private var locale
    let thumbnail: NSImage?

    @State private var isDropTargeted = false

    var body: some View {
        @Bindable var model = model

        VStack(spacing: 18) {
            previewCard

            GlassEffectContainer(spacing: 14) {
                HStack(spacing: 14) {
                    controlButton(
                        systemImage: model.isPlaying ? "pause.fill" : "play.fill",
                        prominent: true
                    ) {
                        model.togglePlayback()
                    }
                    .disabled(model.mediaURL == nil || !model.isVideoContent)

                    controlButton(systemImage: "folder") {
                        pickMedia()
                    }

                    controlButton(systemImage: "xmark") {
                        model.stop()
                    }
                    .disabled(!model.isActive)
                }
            }

            Picker("", selection: $model.fillMode) {
                ForEach(FillMode.allCases) { mode in
                    Text(mode.label(locale: locale)).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .frame(width: 220)

            Spacer()

            settingsCard

            Text(
                String(
                    format: L10n.string("app.version", locale: locale),
                    Self.appVersion
                )
            )
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(20)
        .onDrop(of: [.movie, .image], isTargeted: $isDropTargeted) { providers in
            handleDrop(providers)
        }
    }

    private var previewCard: some View {
        ZStack {
            if let thumbnail {
                Image(nsImage: thumbnail)
                    .resizable()
                    .scaledToFill()
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "sparkles.tv")
                        .font(.system(size: 32, weight: .light))
                        .foregroundStyle(.secondary)
                    LText("preview.drop_hint")
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(width: 280, height: 168)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    isDropTargeted ? Color.accentColor : .white.opacity(0.15),
                    lineWidth: isDropTargeted ? 2 : 1
                )
        )
        .overlay(alignment: .bottomLeading) {
            if let url = model.mediaURL {
                Text(url.deletingPathExtension().lastPathComponent)
                    .font(.caption.weight(.medium))
                    .lineLimit(1)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .glassEffect(.clear, in: Capsule())
                    .padding(10)
            }
        }
        .animation(.smooth(duration: 0.2), value: isDropTargeted)
    }

    private var settingsCard: some View {
        @Bindable var model = model

        return VStack(alignment: .leading, spacing: 14) {
            Label {
                LText("settings.title")
            } icon: {
                Image(systemName: "gearshape")
            }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)

            HStack {
                LText("settings.language")
                    .font(.callout)
                Spacer()
                Picker("", selection: $model.appLanguage) {
                    LText("language.system").tag(AppLanguage.system)
                    Divider()
                    ForEach(AppLanguage.selectable) { lang in
                        Text(lang.nativeName).tag(lang)
                    }
                }
                .labelsHidden()
                .fixedSize()
            }

            HStack {
                LText("settings.display")
                    .font(.callout)
                Spacer()
                Picker("", selection: $model.displayTarget) {
                    LText("display.main").tag(DisplayTarget.main)
                    LText("display.all").tag(DisplayTarget.all)
                    Divider()
                    ForEach(model.availableScreens, id: \.id) { screen in
                        Text(screen.name).tag(DisplayTarget.screen(screen.id))
                    }
                }
                .labelsHidden()
                .fixedSize()
            }

            Toggle(isOn: $model.launchAtLogin) {
                LText("settings.launch_at_login")
            }
                .toggleStyle(.switch)
                .controlSize(.small)
                .font(.callout)

            HStack {
                LText("settings.pixabay_key")
                    .font(.callout)
                Spacer()
                Button {
                    model.pixabayKey = ""
                } label: {
                    LText("settings.change")
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.capsule)
                .controlSize(.small)
                .disabled(model.pixabayKey.isEmpty)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    @ViewBuilder
    private func controlButton(
        systemImage: String,
        prominent: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        let button = Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 28, height: 28)
        }
        .buttonBorderShape(.circle)

        if prominent {
            button.buttonStyle(.glassProminent)
        } else {
            button.buttonStyle(.glass)
        }
    }

    private static var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "dev"
    }

    private func pickMedia() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = AppModel.allowedTypes
        panel.allowsMultipleSelection = false
        panel.message = L10n.string("open_panel.message", locale: locale)
        if panel.runModal() == .OK, let url = panel.url {
            model.select(url: url)
        }
    }

    private func handleDrop(_ providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        _ = provider.loadObject(ofClass: URL.self) { url, _ in
            guard let url else { return }
            Task { @MainActor in
                model.select(url: url)
            }
        }
        return true
    }
}
