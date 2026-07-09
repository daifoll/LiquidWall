import SwiftUI
import AVFoundation
import ServiceManagement
import UniformTypeIdentifiers

enum FillMode: String, CaseIterable, Identifiable {
    case fill
    case fit

    var id: String { rawValue }

    var label: LocalizedStringResource {
        switch self {
        case .fill: "fill_mode.fill"
        case .fit: "fill_mode.fit"
        }
    }

    var gravity: AVLayerVideoGravity {
        switch self {
        case .fill: .resizeAspectFill
        case .fit: .resizeAspect
        }
    }
}

enum GalleryCategory: String, CaseIterable, Identifiable {
    case videos
    case photos

    var id: String { rawValue }

    var label: LocalizedStringResource {
        switch self {
        case .videos: "gallery_category.videos"
        case .photos: "gallery_category.photos"
        }
    }
}

enum ContentPane: String, CaseIterable, Identifiable {
    case gallery
    case library

    var id: String { rawValue }

    var label: LocalizedStringResource {
        switch self {
        case .gallery: "content_pane.gallery"
        case .library: "content_pane.library"
        }
    }
}

struct LibraryItem: Identifiable, Hashable {
    let url: URL
    var id: String { url.path }
    var kind: MediaKind { MediaKind.of(url) }
    var name: String { url.deletingPathExtension().lastPathComponent }
}

@Observable
final class AppModel {

    static let allowedTypes: [UTType] = [.movie, .mpeg4Movie, .quickTimeMovie, .image]

    private let engine = WallpaperEngine()
    private static let savedPathKey = "videoPath"
    private static let pixabayKeyKey = "pixabayAPIKey"
    private static let displayTargetKey = "displayTarget"
    private static let appLanguageKey = "appLanguage"

    var mediaURL: URL?
    var isActive = false
    var isPlaying = false

    var isVideoContent: Bool {
        guard let url = mediaURL else { return false }
        return MediaKind.of(url) == .video
    }

    var fillMode: FillMode = .fill {
        didSet { engine.setGravity(fillMode.gravity) }
    }

    // MARK: - Язык

    var appLanguage: AppLanguage = AppLanguage.resolved(
        from: UserDefaults.standard.string(forKey: appLanguageKey)
    ) {
        didSet {
            UserDefaults.standard.set(appLanguage.rawValue, forKey: Self.appLanguageKey)
        }
    }

    var resolvedLocale: Locale {
        appLanguage.locale
    }

    var pixabayLang: String {
        appLanguage == .system
            ? AppLanguage.fromSystemLocale().pixabayLang
            : appLanguage.pixabayLang
    }

    // MARK: - Мониторы

    var displayTarget: DisplayTarget = .main {
        didSet {
            engine.target = displayTarget
            saveDisplayTarget()
            if isActive, let url = mediaURL {
                start(url: url)
            }
        }
    }

    var availableScreens: [(id: CGDirectDisplayID, name: String)] {
        NSScreen.screens.map { ($0.displayID, $0.localizedName) }
    }

    // MARK: - Автозапуск

    var launchAtLogin: Bool = SMAppService.mainApp.status == .enabled {
        didSet {
            do {
                if launchAtLogin {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                launchAtLogin = SMAppService.mainApp.status == .enabled
            }
        }
    }

    // MARK: - Pixabay и библиотека

    var pixabayKey: String = UserDefaults.standard.string(forKey: pixabayKeyKey) ?? "" {
        didSet { UserDefaults.standard.set(pixabayKey, forKey: Self.pixabayKeyKey) }
    }

    var pane: ContentPane = .gallery
    var category: GalleryCategory = .videos
    var searchQuery = ""
    var items: [GalleryItem] = []
    var isSearching = false
    var isLoadingMore = false
    var searchError: String?

    var downloadProgress: [String: Double] = [:]
    var previewItem: GalleryItem?

    var libraryItems: [LibraryItem] = []

    private var page = 1
    private var totalHits = 0
    private var didRestore = false

    private var client: PixabayClient {
        PixabayClient(apiKey: pixabayKey, lang: pixabayLang)
    }

    init() {
        restoreDisplayTarget()
        engine.target = displayTarget
        refreshLibrary()
    }

    func restoreOnLaunch() {
        guard !didRestore else { return }
        didRestore = true
        if let path = UserDefaults.standard.string(forKey: Self.savedPathKey),
           FileManager.default.fileExists(atPath: path) {
            let url = URL(filePath: path)
            mediaURL = url
            start(url: url)
        }
    }

    // MARK: - Обои

    func select(url: URL) {
        mediaURL = url
        UserDefaults.standard.set(url.path, forKey: Self.savedPathKey)
        start(url: url)
    }

    func togglePlayback() {
        guard isActive else {
            if let url = mediaURL { start(url: url) }
            return
        }
        if isPlaying {
            engine.pause()
            isPlaying = false
        } else {
            engine.resume()
            isPlaying = true
        }
    }

    func stop() {
        engine.stop()
        isActive = false
        isPlaying = false
    }

    private func start(url: URL) {
        engine.start(url: url)
        engine.setGravity(fillMode.gravity)
        isActive = true
        isPlaying = MediaKind.of(url) == .video
    }

    // MARK: - Поиск и пагинация

    func search() async {
        guard !pixabayKey.isEmpty else { return }
        isSearching = true
        searchError = nil
        page = 1
        do {
            let result = try await fetch(page: 1)
            items = result.items
            totalHits = result.totalHits
            if items.isEmpty {
                searchError = String(localized: "error.no_results", bundle: .module)
            }
        } catch {
            items = []
            searchError = error.localizedDescription
        }
        isSearching = false
    }

    func loadMoreIfNeeded(after item: GalleryItem) async {
        guard item.id == items.last?.id,
              !isLoadingMore, !isSearching,
              items.count < min(totalHits, PixabayClient.maxResults) else { return }

        isLoadingMore = true
        do {
            let result = try await fetch(page: page + 1)
            page += 1
            items.append(contentsOf: result.items)
        } catch {
            searchError = error.localizedDescription
        }
        isLoadingMore = false
    }

    private func fetch(page: Int) async throws -> PixabayClient.Page {
        let query = searchQuery.trimmingCharacters(in: .whitespaces)
        return switch category {
        case .videos: try await client.searchVideos(query: query, page: page)
        case .photos: try await client.searchImages(query: query, page: page)
        }
    }

    // MARK: - Загрузка

    var isDownloading: (GalleryItem) -> Bool {
        { [downloadProgress] in downloadProgress[$0.id] != nil }
    }

    func downloadAndApply(_ item: GalleryItem) async {
        guard downloadProgress[item.id] == nil else { return }
        downloadProgress[item.id] = 0
        defer { downloadProgress[item.id] = nil }
        do {
            let url = try await client.download(item) { [weak self] fraction in
                Task { @MainActor in
                    self?.downloadProgress[item.id] = fraction
                }
            }
            refreshLibrary()
            select(url: url)
        } catch {
            let template = String(localized: "error.download_failed", bundle: .module)
            searchError = String(format: template, error.localizedDescription)
        }
    }

    // MARK: - Библиотека загруженного

    func refreshLibrary() {
        let contents = (try? FileManager.default.contentsOfDirectory(
            at: PixabayClient.libraryDirectory,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: .skipsHiddenFiles
        )) ?? []

        libraryItems = contents
            .sorted { lhs, rhs in
                let lhsDate = (try? lhs.resourceValues(forKeys: [.contentModificationDateKey]))?
                    .contentModificationDate ?? .distantPast
                let rhsDate = (try? rhs.resourceValues(forKeys: [.contentModificationDateKey]))?
                    .contentModificationDate ?? .distantPast
                return lhsDate > rhsDate
            }
            .map { LibraryItem(url: $0) }
    }

    func deleteLibraryItem(_ item: LibraryItem) {
        if mediaURL == item.url {
            stop()
            mediaURL = nil
            UserDefaults.standard.removeObject(forKey: Self.savedPathKey)
        }
        try? FileManager.default.removeItem(at: item.url)
        refreshLibrary()
    }

    // MARK: - Персистентность

    private func saveDisplayTarget() {
        let value: String = switch displayTarget {
        case .main: "main"
        case .all: "all"
        case .screen(let id): "screen:\(id)"
        }
        UserDefaults.standard.set(value, forKey: Self.displayTargetKey)
    }

    private func restoreDisplayTarget() {
        guard let value = UserDefaults.standard.string(forKey: Self.displayTargetKey) else { return }
        if value == "all" {
            displayTarget = .all
        } else if value.hasPrefix("screen:"), let id = CGDirectDisplayID(value.dropFirst(7)) {
            displayTarget = .screen(id)
        } else {
            displayTarget = .main
        }
    }
}
