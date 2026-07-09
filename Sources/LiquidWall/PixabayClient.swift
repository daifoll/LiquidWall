import Foundation

// MARK: - Модели

/// Клиент для Pixabay API: https://pixabay.com/api/docs/
struct PixabayVideo: Decodable, Hashable {
    struct Rendition: Decodable, Hashable {
        let url: String
        let width: Int
        let height: Int
        let size: Int
        let thumbnail: String
    }

    struct Renditions: Decodable, Hashable {
        let large: Rendition
        let medium: Rendition
        let small: Rendition
        let tiny: Rendition
    }

    let id: Int
    let tags: String
    let duration: Int
    let user: String
    let videos: Renditions

    /// Лучшее доступное качество: у части роликов large пустой
    var best: Rendition {
        videos.large.url.isEmpty ? videos.medium : videos.large
    }
}

struct PixabayImage: Decodable, Hashable {
    let id: Int
    let tags: String
    let user: String
    let webformatURL: String
    let largeImageURL: String
    // Доступны только одобренным аккаунтам, поэтому опциональные
    let fullHDURL: String?
    let imageURL: String?

    var bestURLString: String {
        imageURL ?? fullHDURL ?? largeImageURL
    }
}

/// Единый элемент галереи: видео или картинка
enum GalleryItem: Identifiable, Hashable {
    case video(PixabayVideo)
    case photo(PixabayImage)

    var id: String {
        switch self {
        case .video(let video): "v\(video.id)"
        case .photo(let photo): "p\(photo.id)"
        }
    }

    var thumbnailURL: URL? {
        switch self {
        case .video(let video): URL(string: video.videos.medium.thumbnail)
        case .photo(let photo): URL(string: photo.webformatURL)
        }
    }

    var tags: String {
        switch self {
        case .video(let video): video.tags
        case .photo(let photo): photo.tags
        }
    }

    /// Бейдж на карточке: длительность для видео, nil для картинок
    func badge(locale: Locale = .current) -> String? {
        switch self {
        case .video(let video):
            let format = String(localized: "duration.seconds", bundle: AppBundle.resources, locale: locale)
            return String(format: format, locale: locale, video.duration)
        case .photo:
            return nil
        }
    }

    var author: String {
        switch self {
        case .video(let video): video.user
        case .photo(let photo): photo.user
        }
    }

    /// URL для потокового предпросмотра — умышленно низкое качество,
    /// полный файл скачивается только при установке
    var previewURL: URL? {
        switch self {
        case .video(let video): URL(string: video.videos.small.url)
        case .photo(let photo): URL(string: photo.webformatURL)
        }
    }
}

enum PixabayError: LocalizedError {
    case invalidKey
    case rateLimited
    case server(Int)
    case badURL

    var errorDescription: String? {
        switch self {
        case .invalidKey:
            String(localized: "pixabay.error.invalid_key", bundle: AppBundle.resources)
        case .rateLimited:
            String(localized: "pixabay.error.rate_limited", bundle: AppBundle.resources)
        case .server(let code):
            String(format: String(localized: "pixabay.error.server", bundle: AppBundle.resources), code)
        case .badURL:
            String(localized: "pixabay.error.bad_url", bundle: AppBundle.resources)
        }
    }
}

// MARK: - Клиент

struct PixabayClient {
    struct Page {
        let items: [GalleryItem]
        let totalHits: Int
    }

    // API отдаёт максимум 500 результатов на запрос
    static let maxResults = 500
    static let perPage = 30

    let apiKey: String
    let lang: String

    func searchVideos(query: String, page: Int) async throws -> Page {
        struct Response: Decodable {
            let totalHits: Int
            let hits: [PixabayVideo]
        }
        let data = try await request(endpoint: "https://pixabay.com/api/videos/", query: query, page: page)
        let response = try JSONDecoder().decode(Response.self, from: data)
        return Page(items: response.hits.map { .video($0) }, totalHits: response.totalHits)
    }

    func searchImages(query: String, page: Int) async throws -> Page {
        struct Response: Decodable {
            let totalHits: Int
            let hits: [PixabayImage]
        }
        let data = try await request(
            endpoint: "https://pixabay.com/api/",
            query: query,
            page: page,
            extra: [
                URLQueryItem(name: "image_type", value: "photo"),
                URLQueryItem(name: "orientation", value: "horizontal"),
                URLQueryItem(name: "min_width", value: "1280"),
            ]
        )
        let response = try JSONDecoder().decode(Response.self, from: data)
        return Page(items: response.hits.map { .photo($0) }, totalHits: response.totalHits)
    }

    private func request(
        endpoint: String,
        query: String,
        page: Int,
        extra: [URLQueryItem] = []
    ) async throws -> Data {
        var components = URLComponents(string: endpoint)!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "lang", value: lang),
            URLQueryItem(name: "safesearch", value: "true"),
            URLQueryItem(name: "per_page", value: String(Self.perPage)),
            URLQueryItem(name: "page", value: String(page)),
        ] + extra

        let (data, response) = try await URLSession.shared.data(from: components.url!)
        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            switch http.statusCode {
            case 400...403: throw PixabayError.invalidKey
            case 429: throw PixabayError.rateLimited
            default: throw PixabayError.server(http.statusCode)
            }
        }
        return data
    }

    // MARK: - Скачивание

    /// Отдаёт прогресс загрузки через колбэк делегата URLSession
    private nonisolated final class ProgressDelegate: NSObject, URLSessionDownloadDelegate {
        private let onProgress: @Sendable (Double) -> Void

        init(onProgress: @escaping @Sendable (Double) -> Void) {
            self.onProgress = onProgress
        }

        func urlSession(
            _ session: URLSession,
            downloadTask: URLSessionDownloadTask,
            didWriteData bytesWritten: Int64,
            totalBytesWritten: Int64,
            totalBytesExpectedToWrite: Int64
        ) {
            guard totalBytesExpectedToWrite > 0 else { return }
            onProgress(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
        }

        // Файл обрабатывает async-обёртка download(from:delegate:)
        func urlSession(
            _ session: URLSession,
            downloadTask: URLSessionDownloadTask,
            didFinishDownloadingTo location: URL
        ) {}
    }

    /// Скачивает медиа в папку библиотеки и возвращает локальный URL.
    /// Загрузки независимы, поэтому несколько вызовов работают параллельно.
    func download(
        _ item: GalleryItem,
        onProgress: @escaping @Sendable (Double) -> Void
    ) async throws -> URL {
        let remote: URL?
        let filename: String

        switch item {
        case .video(let video):
            remote = URL(string: video.best.url)
            filename = "pixabay-\(video.id).mp4"
        case .photo(let photo):
            remote = URL(string: photo.bestURLString)
            let ext = remote?.pathExtension.isEmpty == false ? remote!.pathExtension : "jpg"
            filename = "pixabay-\(photo.id).\(ext)"
        }

        guard let remote else {
            throw PixabayError.badURL
        }

        let destination = Self.libraryDirectory.appending(path: filename)
        if FileManager.default.fileExists(atPath: destination.path) {
            return destination
        }

        let (temporary, _) = try await URLSession.shared.download(
            from: remote,
            delegate: ProgressDelegate(onProgress: onProgress)
        )
        try FileManager.default.createDirectory(at: Self.libraryDirectory, withIntermediateDirectories: true)
        try? FileManager.default.removeItem(at: destination)
        try FileManager.default.moveItem(at: temporary, to: destination)
        return destination
    }

    static var libraryDirectory: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appending(path: "LiquidWall/Videos")
    }
}
