import Foundation
import SwiftUI

/// Ресурсный bundle приложения — доступен вне MainActor (в отличие от `Bundle.module`).
enum AppBundle {
    private final class Token: NSObject {}

    nonisolated private static let _resources: Bundle = {
        let bundleName = "LiquidWall_LiquidWall.bundle"

        let inApp = Bundle.main.bundleURL.appendingPathComponent(bundleName)
        if let bundle = Bundle(path: inApp.path) {
            return bundle
        }

        if let url = Bundle.main.url(forResource: "LiquidWall_LiquidWall", withExtension: "bundle"),
           let bundle = Bundle(url: url) {
            return bundle
        }

        if let exec = Bundle.main.executableURL {
            let nextToExec = exec.deletingLastPathComponent().appendingPathComponent(bundleName)
            if let bundle = Bundle(path: nextToExec.path) {
                return bundle
            }
        }

        return Bundle(for: Token.self)
    }()

    nonisolated static var resources: Bundle { _resources }
}

enum L10n {
    /// Явный lookup в .lproj — String(localized:locale:) не работает для SPM bundle
    nonisolated static func string(_ key: String, locale: Locale, bundle: Bundle = AppBundle.resources) -> String {
        for name in lprojCandidates(for: locale) {
            guard let path = bundle.path(forResource: name, ofType: "lproj"),
                  let locBundle = Bundle(path: path) else { continue }
            let value = locBundle.localizedString(forKey: key, value: nil, table: nil)
            if value != key { return value }
        }
        return bundle.localizedString(forKey: key, value: key, table: nil)
    }

    nonisolated private static func lprojCandidates(for locale: Locale) -> [String] {
        var names: [String] = []
        let id = locale.identifier.replacing("_", with: "-")
        names.append(id)
        names.append(id.lowercased())
        if let code = locale.language.languageCode?.identifier {
            names.append(code)
        }
        names.append("en")
        var seen = Set<String>()
        return names.filter { seen.insert($0).inserted }
    }
}

/// Локализованный Text с явным lookup в .lproj
struct LText: View {
    let key: String
    @Environment(\.locale) private var locale

    init(_ key: String) {
        self.key = key
    }

    var body: some View {
        Text(L10n.string(key, locale: locale))
    }
}

/// Поддерживаемые языки интерфейса
enum AppLanguage: String, CaseIterable, Identifiable, Codable {
    case system
    case en
    case ru
    case zhHans = "zh-Hans"
    case ja
    case de
    case es
    case ptBR = "pt-BR"
    case fr
    case ko
    case pl

    var id: String { rawValue }

    /// Языки для пикера (без system — он отдельно)
    static let selectable: [AppLanguage] = allCases.filter { $0 != .system }

    /// Название языка на самом языке (для пикера)
    var nativeName: String {
        switch self {
        case .system: ""
        case .en: "English"
        case .ru: "Русский"
        case .zhHans: "简体中文"
        case .ja: "日本語"
        case .de: "Deutsch"
        case .es: "Español"
        case .ptBR: "Português (Brasil)"
        case .fr: "Français"
        case .ko: "한국어"
        case .pl: "Polski"
        }
    }

    var pixabayLang: String {
        switch self {
        case .system: AppLanguage.fromSystemLocale().pixabayLang
        case .en: "en"
        case .ru: "ru"
        case .zhHans: "zh"
        case .ja: "ja"
        case .de: "de"
        case .es: "es"
        case .ptBR: "pt"
        case .fr: "fr"
        case .ko: "ko"
        case .pl: "pl"
        }
    }

    var locale: Locale {
        switch self {
        case .system: Locale.current
        default: Locale(identifier: rawValue)
        }
    }

    static func fromSystemLocale() -> AppLanguage {
        let preferred = Locale.preferredLanguages.first ?? "en"
        if preferred.hasPrefix("ru") { return .ru }
        if preferred.hasPrefix("zh") { return .zhHans }
        if preferred.hasPrefix("ja") { return .ja }
        if preferred.hasPrefix("de") { return .de }
        if preferred.hasPrefix("es") { return .es }
        if preferred.hasPrefix("pt") { return .ptBR }
        if preferred.hasPrefix("fr") { return .fr }
        if preferred.hasPrefix("ko") { return .ko }
        if preferred.hasPrefix("pl") { return .pl }
        return .en
    }

    static func resolved(from stored: String?) -> AppLanguage {
        guard let stored, let lang = AppLanguage(rawValue: stored) else { return .en }
        return lang
    }
}
