import AppKit

final class Launch: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 600, height: 400), styleMask: [.borderless, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView], backing: .buffered, defer: false)
        center()
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
    }
    
    override func close() {
        if NSApp.windows.count == 1 {
            NSApp.terminate(nil)
        } else {
            super.close()
        }
    }
}
