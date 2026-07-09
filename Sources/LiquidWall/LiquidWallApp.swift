import SwiftUI

/// Окна-обоев всегда «видимы», поэтому системный механизм повторного открытия
/// главного окна по клику на иконку в доке не срабатывает (hasVisibleWindows == true).
final class AppDelegate: NSObject, NSApplicationDelegate {
    nonisolated(unsafe) static var openMainWindow: (() -> Void)?
    nonisolated(unsafe) static var openHelpWindow: (() -> Void)?

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        guard let openMainWindow = Self.openMainWindow else { return true }
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
                .environment(\.locale, model.resolvedLocale)
                .containerBackground(.thinMaterial, for: .window)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .windowBackgroundDragBehavior(.enabled)
        .defaultSize(ContentView.windowSize)
        .defaultLaunchBehavior(.presented)
        .restorationBehavior(.disabled)
        .commands {
            CommandGroup(replacing: .help) {
                Button {
                    AppDelegate.openHelpWindow?()
                } label: {
                    Text("menu.help", bundle: .module)
                }
                .keyboardShortcut("?", modifiers: .command)
            }
        }

        Window("LiquidWall Help", id: "help") {
            HelpView()
                .environment(model)
                .environment(\.locale, model.resolvedLocale)
                .containerBackground(.thinMaterial, for: .window)
        }
        .windowResizability(.contentSize)
        .restorationBehavior(.disabled)
    }
}
