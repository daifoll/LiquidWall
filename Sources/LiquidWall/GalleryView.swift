import SwiftUI
import AVFoundation

/// Простой видеоплеер на AVPlayerLayer.
/// AVKit-овский VideoPlayer крашится в SPM-бинаре при сборке без Xcode-проекта
/// (fatalError в рантайме при инстанцировании метаданных класса).
private struct PlayerLayerView: NSViewRepresentable {
    let player: AVPlayer

    /// AVPlayerLayer как backing layer вью — размер всегда совпадает с вью,
    /// не нужно вручную синхронизировать frame при layout
    final class PlayerNSView: NSView {
        private let playerLayer = AVPlayerLayer()

        init() {
            super.init(frame: .zero)
            wantsLayer = true
            playerLayer.videoGravity = .resizeAspectFill
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }

        override func makeBackingLayer() -> CALayer { playerLayer }

        var player: AVPlayer? {
            get { playerLayer.player }
            set { playerLayer.player = newValue }
        }
    }

    func makeNSView(context: Context) -> PlayerNSView {
        let view = PlayerNSView()
        view.player = player
        return view
    }

    func updateNSView(_ nsView: PlayerNSView, context: Context) {
        if nsView.player !== player {
            nsView.player = player
        }
    }
}

// MARK: - Онбординг: запрос API-ключа с инструкцией

struct OnboardingView: View {
    @Environment(AppModel.self) private var model
    @State private var draft = ""

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "key.radiowaves.forward")
                .font(.system(size: 42, weight: .light))
                .foregroundStyle(.secondary)

            Text("Подключи галерею Pixabay")
                .font(.title2.weight(.semibold))

            Text("Тысячи бесплатных видео и картинок для обоев.\nНужен только API-ключ — он бесплатный, получается за пару минут.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 12) {
                instructionRow(number: 1) {
                    Text("Зарегистрируйся на [pixabay.com](https://pixabay.com/ru/accounts/register/)")
                }
                instructionRow(number: 2) {
                    Text("Открой страницу [документации API](https://pixabay.com/api/docs/)")
                }
                instructionRow(number: 3) {
                    Text("Ключ показан в разделе «Parameters» рядом с полем **key**")
                }
                instructionRow(number: 4) {
                    Text("Вставь его сюда:")
                }
            }
            .padding(20)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

            HStack(spacing: 10) {
                SecureField("API-ключ", text: $draft)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .glassEffect(.regular, in: Capsule())
                    .onSubmit(save)
                Button("Сохранить", action: save)
                    .buttonStyle(.glassProminent)
                    .buttonBorderShape(.capsule)
                    // .large подгоняет высоту кнопок под инпуты (вертикальный padding 8),
                    // чтобы радиус капсулы совпадал
                    .controlSize(.large)
                    .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .frame(width: 360)
        }
        .padding(40)
    }

    private func instructionRow(number: Int, @ViewBuilder content: () -> some View) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text("\(number)")
                .font(.footnote.weight(.bold))
                .frame(width: 22, height: 22)
                .glassEffect(.clear, in: Circle())
            content()
                .font(.callout)
        }
    }

    private func save() {
        model.pixabayKey = draft.trimmingCharacters(in: .whitespaces)
    }
}

// MARK: - Галерея Pixabay

struct GalleryPane: View {
    @Environment(AppModel.self) private var model
    @FocusState private var searchFocused: Bool

    private let columns = [GridItem(.adaptive(minimum: 190), spacing: 12)]

    var body: some View {
        @Bindable var model = model

        VStack(spacing: 0) {
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Поиск: nature, ocean, rain…", text: $model.searchQuery)
                        .textFieldStyle(.plain)
                        .focused($searchFocused)
                        .onSubmit { Task { await model.search() } }
                    if !model.searchQuery.isEmpty {
                        Button {
                            model.searchQuery = ""
                            searchFocused = true
                            Task { await model.search() }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                        .help("Очистить запрос")
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .glassEffect(.regular.interactive(), in: Capsule())
                .animation(.smooth(duration: 0.15), value: model.searchQuery.isEmpty)

                Picker("", selection: $model.category) {
                    ForEach(GalleryCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .fixedSize()
                .onChange(of: model.category) {
                    Task { await model.search() }
                }

                if model.isSearching {
                    ProgressView()
                        .controlSize(.small)
                }
            }
            .padding(16)

            if let error = model.searchError {
                Text(error)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(model.items) { item in
                        MediaCard(item: item)
                            .task {
                                await model.loadMoreIfNeeded(after: item)
                            }
                    }
                }
                .padding(.horizontal, 16)

                if model.isLoadingMore {
                    ProgressView()
                        .controlSize(.small)
                        .padding(.vertical, 12)
                }
            }

            Text("Медиа предоставлены [Pixabay](https://pixabay.com)")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.vertical, 8)
        }
        .task {
            searchFocused = true
            if model.items.isEmpty {
                await model.search()
            }
        }
    }
}

// MARK: - Карточка медиа

private struct MediaCard: View {
    @Environment(AppModel.self) private var model
    let item: GalleryItem

    @State private var isHovering = false

    private var progress: Double? {
        model.downloadProgress[item.id]
    }

    var body: some View {
        Button {
            model.previewItem = item
        } label: {
            ZStack {
                AsyncImage(url: item.thumbnailURL) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFill()
                    } else {
                        Rectangle().fill(.quaternary)
                    }
                }
                // Без этого scaledToFill расширяет layout и hit-область карточки
                .frame(minWidth: 0, maxWidth: .infinity)

                if let progress {
                    Rectangle().fill(.black.opacity(0.45))
                    VStack(spacing: 6) {
                        ProgressView(value: progress)
                            .progressViewStyle(.linear)
                            .frame(width: 100)
                        Text("\(Int(progress * 100)) %")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                } else if isHovering {
                    Rectangle().fill(.black.opacity(0.3))
                    Image(systemName: "eye.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.white)
                }
            }
            .frame(height: 116)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            // Ограничиваем hit-область видимой формой карточки, иначе
            // «вылезшее» изображение перехватывает наведение у соседних карточек
            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(alignment: .bottomLeading) {
                if let badge = item.badge {
                    cardCapsule(systemImage: "clock", text: badge)
                        .padding(7)
                        .opacity(isHovering || progress != nil ? 0 : 1)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                cardCapsule(systemImage: "person", text: item.author)
                    .padding(7)
                    .opacity(progress != nil ? 0 : 1)
            }
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .animation(.smooth(duration: 0.15), value: isHovering)
        .help(item.tags)
    }
}

private func cardCapsule(systemImage: String, text: String) -> some View {
    HStack(spacing: 4) {
        Image(systemName: systemImage)
            .font(.system(size: 8))
        Text(text)
            .font(.caption2.weight(.medium))
            .lineLimit(1)
    }
    .padding(.horizontal, 7)
    .padding(.vertical, 3)
    .glassEffect(.clear, in: Capsule())
}

// MARK: - Предпросмотр перед установкой

struct PreviewSheet: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    let item: GalleryItem

    @State private var player: AVQueuePlayer?
    @State private var looper: AVPlayerLooper?

    private var progress: Double? {
        model.downloadProgress[item.id]
    }

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                switch item {
                case .video:
                    if let player {
                        PlayerLayerView(player: player)
                    } else {
                        ProgressView()
                    }
                case .photo:
                    AsyncImage(url: item.previewURL) { phase in
                        if let image = phase.image {
                            image.resizable().scaledToFill()
                        } else {
                            ProgressView()
                        }
                    }
                }
            }
            .frame(width: 640, height: 360)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Label(item.author, systemImage: "person")
                        .font(.callout.weight(.medium))
                    Text(item.tags)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Button("Закрыть") { dismiss() }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.capsule)
                    .controlSize(.large)

                if let progress {
                    ProgressView(value: progress)
                        .progressViewStyle(.linear)
                        .frame(width: 120)
                } else {
                    Button("Установить") {
                        Task {
                            await model.downloadAndApply(item)
                            dismiss()
                        }
                    }
                    .buttonStyle(.glassProminent)
                    .buttonBorderShape(.capsule)
                    .controlSize(.large)
                }
            }
            .frame(width: 640)
        }
        .padding(20)
        .onAppear {
            if case .video = item, let url = item.previewURL {
                let playerItem = AVPlayerItem(url: url)
                let player = AVQueuePlayer(playerItem: playerItem)
                player.isMuted = true
                looper = AVPlayerLooper(player: player, templateItem: playerItem)
                player.play()
                self.player = player
            }
        }
        .onDisappear {
            player?.pause()
            player?.removeAllItems()
            looper = nil
            player = nil
        }
    }
}

// MARK: - Загруженные

struct LibraryPane: View {
    @Environment(AppModel.self) private var model

    private let columns = [GridItem(.adaptive(minimum: 190), spacing: 12)]

    var body: some View {
        VStack(spacing: 0) {
            if model.libraryItems.isEmpty {
                Spacer()
                VStack(spacing: 10) {
                    Image(systemName: "square.stack.3d.up.slash")
                        .font(.system(size: 32, weight: .light))
                        .foregroundStyle(.secondary)
                    Text("Пока ничего не скачано")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(model.libraryItems) { item in
                            LibraryCard(item: item)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .onAppear {
            model.refreshLibrary()
        }
    }
}

private struct LibraryCard: View {
    @Environment(AppModel.self) private var model
    let item: LibraryItem

    @State private var thumbnail: NSImage?
    @State private var isHovering = false

    private var isCurrent: Bool {
        model.mediaURL == item.url
    }

    var body: some View {
        Button {
            model.select(url: item.url)
        } label: {
            ZStack {
                if let thumbnail {
                    Image(nsImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                } else {
                    Rectangle().fill(.quaternary)
                }

                if isHovering && !isCurrent {
                    Rectangle().fill(.black.opacity(0.3))
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.white)
                }
            }
            .frame(height: 116)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(
                        isCurrent ? Color.accentColor : .clear,
                        lineWidth: 2
                    )
            )
            .overlay(alignment: .bottomLeading) {
                cardCapsule(
                    systemImage: item.kind == .video ? "film" : "photo",
                    text: item.name
                )
                .padding(7)
            }
            .overlay(alignment: .topTrailing) {
                if isHovering {
                    Button {
                        model.deleteLibraryItem(item)
                    } label: {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .tint(.red)
                    .padding(6)
                }
            }
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .animation(.smooth(duration: 0.15), value: isHovering)
        .task(id: item.url) {
            thumbnail = await MediaThumbnailer.thumbnail(for: item.url, maxSize: 400)
        }
    }
}
