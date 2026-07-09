import SwiftUI

/// Справка приложения
struct HelpView: View {
    @Environment(\.locale) private var locale

    private var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "dev"
    }

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
                        Text(
                            String(
                                format: L10n.string("help.subtitle", locale: locale),
                                version
                            )
                        )
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    }
                }

                section("help.about.title") {
                    LText("help.about.body")
                }

                section("help.getting_started.title") {
                    LText("help.getting_started.body")
                }

                section("help.displays.title") {
                    LText("help.displays.body")
                }

                section("help.power.title") {
                    LText("help.power.body")
                }

                section("help.notes.title") {
                    LText("help.notes.body")
                }

                Divider()

                HStack(spacing: 6) {
                    Image(systemName: "person.crop.circle")
                        .foregroundStyle(.secondary)
                    LText("help.created_by")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Link("github.com/daifoll", destination: URL(string: "https://github.com/daifoll")!)
                }

                LText("help.ai_dev_credit")
                    .font(.caption)
                    .foregroundStyle(.tertiary)

                LText("help.ai_translation_note")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding(28)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 520, height: 560)
    }

    private func section(_ titleKey: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            LText(titleKey)
                .font(.headline)
            content()
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }
}
