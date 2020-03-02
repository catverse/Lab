import AppKit

final class Window: NSWindow {
    private let bookmark: Bookmark
    
    init(_ bookmark: Bookmark) {
        self.bookmark = bookmark
        super.init(contentRect: .init(x: 0, y: 0, width: 900, height: 600), styleMask: [.borderless, .miniaturizable, .resizable, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView], backing: .buffered, defer: false)
        minSize = .init(width: 300, height: 300)
        center()
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
        let blur = NSVisualEffectView()
        blur.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(blur)
        
        let title = Label(bookmark.id.deletingPathExtension().lastPathComponent, .medium(12))
        contentView!.addSubview(title)
        
        let separator = Separator()
        contentView!.addSubview(separator)
        
        let sideScroll = Scroll()
        contentView!.addSubview(sideScroll)
        
        blur.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        blur.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        separator.topAnchor.constraint(equalTo: blur.bottomAnchor, constant: 1).isActive = true
        separator.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
        separator.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 200).isActive = true
        
        sideScroll.topAnchor.constraint(equalTo: blur.bottomAnchor, constant: 1).isActive = true
        sideScroll.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        sideScroll.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
        sideScroll.widthAnchor.constraint(equalToConstant: 200).isActive = true
        sideScroll.width.constraint(equalTo: sideScroll.widthAnchor).isActive = true
        
        title.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 80).isActive = true
        title.centerYAnchor.constraint(equalTo: blur.centerYAnchor).isActive = true
        
        var top = sideScroll.top
        [bookmark, bookmark, bookmark].forEach {
            let item = Item($0, self, #selector(self.click(_:)))
            sideScroll.add(item)
            
            item.topAnchor.constraint(equalTo: top).isActive = true
            item.leftAnchor.constraint(equalTo: sideScroll.left).isActive = true
            item.widthAnchor.constraint(equalTo: sideScroll.width).isActive = true
            top = item.bottomAnchor
        }
        sideScroll.bottom.constraint(greaterThanOrEqualTo: top).isActive = true
    }
    
    override func close() {
        if NSApp.windows.count < 2 {
            Launch().makeKeyAndOrderFront(nil)
        }
        super.close()
    }
    
    @objc private func click(_ item: Item) {

    }
}

private final class Item: Control {
    private var opacity = CGFloat(0)
    fileprivate let bookmark: Bookmark
    
    required init?(coder: NSCoder) { nil }
    init(_ bookmark: Bookmark, _ target: AnyObject, _ action: Selector) {
        self.bookmark = bookmark
        super.init(target, action)
        wantsLayer = true
        
        let name = Label(bookmark.id.deletingPathExtension().lastPathComponent, .medium(15))
        addSubview(name)
        
        let url = Label(bookmark.id.deletingLastPathComponent().path, .light(11))
        url.textColor = .secondaryLabelColor
        addSubview(url)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        name.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        name.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        url.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
        url.leftAnchor.constraint(equalTo: name.leftAnchor).isActive = true
    }
    
    override func updateLayer() {
        layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(opacity).cgColor
    }
    
    override func hoverOn() {
        opacity = 0.6
        updateLayer()
    }
    
    override func hoverOff() {
        opacity = 0
        updateLayer()
    }
}
