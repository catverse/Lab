import AppKit

final class Launch: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 600, height: 300), styleMask: [.borderless, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView], backing: .buffered, defer: false)
        center()
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
        let title = Label(.key("Launch.title"), .light(25))
        contentView!.addSubview(title)
        
        let button = Button(.key("Launch.button"), self, #selector(open))
        contentView!.addSubview(button)
        
        let blur = NSVisualEffectView()
        blur.material = .sidebar
        blur.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(blur)
        
        let scroll = Scroll()
        contentView!.addSubview(scroll)
        
        title.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 120).isActive = true
        title.centerXAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 150).isActive = true
        
        button.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 30).isActive = true
        button.centerXAnchor.constraint(equalTo: title.centerXAnchor).isActive = true
        
        blur.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        blur.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        scroll.topAnchor.constraint(equalTo: blur.topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: blur.bottomAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: blur.rightAnchor).isActive = true
        scroll.widthAnchor.constraint(equalTo: blur.widthAnchor).isActive = true
    }
    
    override func close() {
        if NSApp.windows.count == 1 {
            NSApp.terminate(nil)
        } else {
            super.close()
        }
    }
    
    @objc private func open() {
        
    }
}
