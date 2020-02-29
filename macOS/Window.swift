import AppKit

final class Window: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 600, height: 400), styleMask: [.borderless, .miniaturizable, .resizable, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView], backing: .buffered, defer: false)
        minSize = .init(width: 200, height: 200)
        center()
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
    }
    
    override func close() {
        (NSApp as! App).launch()
    }
}
