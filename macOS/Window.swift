import Balam
import AppKit
import Combine

final class Window: NSWindow {
    private weak var overview: Overview!
    private weak var scroll: Scroll!
    private var url: URL?
    private var sub: AnyCancellable?
    
    init(_ bookmark: Bookmark) {
        super.init(contentRect: .init(x: 0, y: 0, width: 900, height: 600), styleMask: [.borderless, .miniaturizable, .resizable, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView], backing: .buffered, defer: false)
        minSize = .init(width: 400, height: 300)
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
        title.textColor = .secondaryLabelColor
        contentView!.addSubview(title)
        
        let separator = Separator()
        contentView!.addSubview(separator)
        
        let scroll = Scroll()
        contentView!.addSubview(scroll)
        self.scroll = scroll
        
        let overview = Overview()
        contentView!.addSubview(overview)
        self.overview = overview
        
        blur.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        blur.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        separator.topAnchor.constraint(equalTo: blur.bottomAnchor, constant: 1).isActive = true
        separator.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
        separator.leftAnchor.constraint(equalTo: scroll.right).isActive = true
        
        scroll.topAnchor.constraint(equalTo: blur.bottomAnchor, constant: 1).isActive = true
        scroll.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
        scroll.widthAnchor.constraint(equalToConstant: 200).isActive = true
        scroll.width.constraint(equalTo: scroll.widthAnchor).isActive = true
        
        overview.topAnchor.constraint(equalTo: blur.bottomAnchor, constant: 1).isActive = true
        overview.leftAnchor.constraint(equalTo: separator.rightAnchor).isActive = true
        overview.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
        overview.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        overview.width.constraint(equalTo: overview.widthAnchor).isActive = true
        
        title.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 80).isActive = true
        title.centerYAnchor.constraint(equalTo: blur.centerYAnchor).isActive = true
        
        var stale = false
        guard
            let url = try? URL(resolvingBookmarkData: bookmark.access, options: .withSecurityScope, bookmarkDataIsStale: &stale),
            url.startAccessingSecurityScopedResource()
        else { return }
        self.url = url
        
        sub = Balam.nodes(url).receive(on: DispatchQueue.main).sink { [weak self] in
            guard let self = self else { return }
            var top = scroll.top
            $0.forEach {
                let item = Item($0, self, #selector(self.click(_:)))
                scroll.add(item)
                
                item.topAnchor.constraint(equalTo: top).isActive = true
                item.leftAnchor.constraint(equalTo: scroll.left).isActive = true
                item.widthAnchor.constraint(equalTo: scroll.width).isActive = true
                top = item.bottomAnchor
            }
            scroll.bottom.constraint(greaterThanOrEqualTo: top).isActive = true
        }
    }
    
    override func close() {
        if NSApp.windows.count < 2 {
            Launch().makeKeyAndOrderFront(nil)
        }
        url?.stopAccessingSecurityScopedResource()
        super.close()
    }
    
    @objc private func click(_ item: Item) {
        guard !item.selected else { return }
        scroll.views.map { $0 as! Item }.forEach { $0.selected = false }
        item.selected = true
        overview.node = item.node
    }
}

private final class Item: Control {
    fileprivate var selected = false {
        didSet {
            updateLayer()
        }
    }
    
    fileprivate let node: Node
    
    required init?(coder: NSCoder) { nil }
    init(_ node: Node, _ target: AnyObject, _ action: Selector) {
        self.node = node
        super.init(target, action)
        wantsLayer = true
        
        let name = Label(node.name, .medium(15))
        addSubview(name)
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        name.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
    }
    
    override func updateLayer() {
        layer!.backgroundColor = selected ? NSColor.controlAccentColor.cgColor : .clear
    }
}
