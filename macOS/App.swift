import AppKit

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        launch()
    }
    
    func launch() {
        if windows.isEmpty {
            Launch().makeKeyAndOrderFront(nil)
        }
    }
}
