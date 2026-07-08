import SwiftUI

/// Справка приложения (на английском)
struct HelpView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 14) {
                    Image(nsImage: NSApp.applicationIconImage)
                        .resizable()
                        .frame(width: 56, height: 56)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("LiquidWall")
                            .font(.title2.weight(.semibold))
                        Text("Live wallpapers for macOS · v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "dev")")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }

                section("About") {
                    Text("""
                    LiquidWall turns any video or image into a live desktop wallpaper. \
                    Content is rendered in a borderless window at the desktop level — above the \
                    system wallpaper, below your icons and app windows. Video decoding is fully \
                    hardware-accelerated (AVFoundation), so CPU usage stays minimal.
                    """)
                }

                section("Getting Started") {
                    Text("""
                    • Drag & drop a video (MP4, MOV) or image onto the preview card, \
                    or click the folder button to pick a file.
                    • Browse the built-in Pixabay gallery: search thousands of free videos \
                    and photos, preview them, and apply in one click. A free API key from \
                    [pixabay.com/api/docs](https://pixabay.com/api/docs/) is required.
                    • Downloaded files are kept in the Library tab, where you can re-apply \
                    or delete them.
                    """)
                }

                section("Displays") {
                    Text("""
                    By default the wallpaper is shown on the main display. Use the Screen \
                    picker in Settings to target all displays or a specific one.
                    """)
                }

                section("Power Efficiency") {
                    Text("""
                    Playback pauses automatically when the desktop is fully covered by \
                    windows or a full-screen app, when the screen is locked, and during \
                    sleep. The wallpaper never prevents your display from sleeping.
                    """)
                }

                section("Notes") {
                    Text("""
                    • The wallpaper is not visible over full-screen apps.
                    • Media provided by [Pixabay](https://pixabay.com) under the Pixabay \
                    Content License.
                    """)
                }

                Divider()

                HStack(spacing: 6) {
                    Image(systemName: "person.crop.circle")
                        .foregroundStyle(.secondary)
                    Text("Created by **daifoll** · [github.com/daifoll](https://github.com/daifoll)")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }

                Text("Built with AI-assisted development (vibe coding) using the **Fable 5** model in Cursor.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(28)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 520, height: 560)
    }

    private func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            content()
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }
}
