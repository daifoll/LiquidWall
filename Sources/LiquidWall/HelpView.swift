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
                                format: String(localized: "help.subtitle", bundle: .module, locale: locale),
                                locale: locale,
                                version
                            )
                        )
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    }
                }

                section(LocalizedStringResource("help.about.title", bundle: .module)) {
                    Text("help.about.body", bundle: .module)
                }

                section(LocalizedStringResource("help.getting_started.title", bundle: .module)) {
                    Text("help.getting_started.body", bundle: .module)
                }

                section(LocalizedStringResource("help.displays.title", bundle: .module)) {
                    Text("help.displays.body", bundle: .module)
                }

                section(LocalizedStringResource("help.power.title", bundle: .module)) {
                    Text("help.power.body", bundle: .module)
                }

                section(LocalizedStringResource("help.notes.title", bundle: .module)) {
                    Text("help.notes.body", bundle: .module)
                }

                Divider()

                HStack(spacing: 6) {
                    Image(systemName: "person.crop.circle")
                        .foregroundStyle(.secondary)
                    Text("help.created_by", bundle: .module)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Link("github.com/daifoll", destination: URL(string: "https://github.com/daifoll")!)
                }

                Text("help.ai_dev_credit", bundle: .module)
                    .font(.caption)
                    .foregroundStyle(.tertiary)

                Text("help.ai_translation_note", bundle: .module)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding(28)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 520, height: 560)
    }

    private func section(_ title: LocalizedStringResource, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            content()
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }
}
