import SwiftUI

/// Окна-обоев всегда «видимы», поэтому системный механизм повторного открытия
/// главного окна по клику на иконку в доке не срабатывает (hasVisibleWindows == true).
/// Делегат открывает главное окно вручную.
final class AppDelegate: NSObject, NSApplicationDelegate {
    static var openMainWindow: (() -> Void)?
    static var openHelpWindow: (() -> Void)?

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        guard let openMainWindow = Self.openMainWindow else {
            // Колбэк ещё не установлен — отдаём reopen системе
            return true
        }
        openMainWindow()
        return false
    }
}

@main
struct LiquidWallApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var model = AppModel()

    var body: some Scene {
        Window("LiquidWall", id: "main") {
            ContentView()
                .environment(model)
                .containerBackground(.thinMaterial, for: .window)
        }
        .windowStyle(.hiddenTitleBar)
        // Фиксированный размер: контент имеет жёсткий frame, ресайз недоступен
        .windowResizability(.contentSize)
        .windowBackgroundDragBehavior(.enabled)
        .defaultSize(ContentView.windowSize)
        // Всегда показывать окно при запуске: иначе система восстанавливает
        // «закрытое» состояние из прошлой сессии, а из-за окон-обоев
        // reopen по клику в доке не срабатывает
        .defaultLaunchBehavior(.presented)
        .restorationBehavior(.disabled)
        .commands {
            CommandGroup(replacing: .help) {
                Button("LiquidWall Help") {
                    AppDelegate.openHelpWindow?()
                }
                .keyboardShortcut("?", modifiers: .command)
            }
        }

        Window("LiquidWall Help", id: "help") {
            HelpView()
                .containerBackground(.thinMaterial, for: .window)
        }
        .windowResizability(.contentSize)
        .restorationBehavior(.disabled)
    }
}
