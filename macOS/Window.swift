import Balam
import AppKit
import Combine

final class Window: NSWindow {
    private weak var overview: Overview!
    private weak var items: Items!
    private weak var list: Scroll!
    private var url: URL?
    private var sub: AnyCancellable?
    private let formatter = NumberFormatter()
    
    init(_ bookmark: Bookmark) {
        super.init(contentRect: .init(x: 0, y: 0, width: 900, height: 600), styleMask: [.borderless, .miniaturizable, .resizable, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView], backing: .buffered, defer: false)
        minSize = .init(width: 300, height: 200)
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
        
        let list = Scroll()
        contentView!.addSubview(list)
        self.list = list
        
        let content = Scroll()
        contentView!.addSubview(content)
        
        let overview = Overview()
        content.add(overview)
        self.overview = overview
        
        let items = Items()
        content.add(items)
        self.items = items
        
        blur.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        blur.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        separator.topAnchor.constraint(equalTo: blur.bottomAnchor, constant: 1).isActive = true
        separator.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
        separator.leftAnchor.constraint(equalTo: list.right).isActive = true
        
        list.topAnchor.constraint(equalTo: blur.bottomAnchor, constant: 1).isActive = true
        list.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
        list.widthAnchor.constraint(equalToConstant: 220).isActive = true
        list.width.constraint(equalTo: list.widthAnchor).isActive = true
        
        content.topAnchor.constraint(equalTo: blur.bottomAnchor, constant: 1).isActive = true
        content.leftAnchor.constraint(equalTo: separator.rightAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
        content.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        content.right.constraint(greaterThanOrEqualTo: content.rightAnchor).isActive = true
        content.right.constraint(greaterThanOrEqualTo: overview.rightAnchor, constant: 30).isActive = true
        content.right.constraint(greaterThanOrEqualTo: items.rightAnchor, constant: 30).isActive = true
        content.bottom.constraint(greaterThanOrEqualTo: items.bottomAnchor, constant: 20).isActive = true
        content.bottom.constraint(greaterThanOrEqualTo: content.bottomAnchor).isActive = true
        
        overview.topAnchor.constraint(equalTo: content.top, constant: 20).isActive = true
        overview.leftAnchor.constraint(equalTo: content.left, constant: 30).isActive = true
        overview.rightAnchor.constraint(greaterThanOrEqualTo: content.rightAnchor, constant: -30).isActive = true
        
        items.topAnchor.constraint(equalTo: overview.bottomAnchor, constant: 40).isActive = true
        items.leftAnchor.constraint(equalTo: content.left, constant: 30).isActive = true
        items.rightAnchor.constraint(greaterThanOrEqualTo: content.rightAnchor, constant: -30).isActive = true
        
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
            var top = list.top
            $0.map(self.item(_:)).forEach {
                list.add($0)
                $0.topAnchor.constraint(equalTo: top).isActive = true
                $0.leftAnchor.constraint(equalTo: list.left).isActive = true
                $0.widthAnchor.constraint(equalTo: list.width).isActive = true
                top = $0.bottomAnchor
            }
            list.bottom.constraint(greaterThanOrEqualTo: top).isActive = true
        }
    }
    
    private func item(_ node: Node) -> Item {
        .init(node, formatter.string(from: .init(value: node.items.count))! + .key(node.items.count == 1 ? "Window.item" : "Window.items"), self, #selector(click(_:)))
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
        list.views.map { $0 as! Item }.forEach { $0.selected = false }
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
    init(_ node: Node, _ items: String, _ target: AnyObject, _ action: Selector) {
        self.node = node
        super.init(target, action)
        wantsLayer = true
        
        let name = Label(node.name, .medium(15))
        addSubview(name)
        
        let items = Label(items, .regular(12))
        items.textColor = .secondaryLabelColor
        items.setContentHuggingPriority(.defaultLow, for: .horizontal)
        addSubview(items)
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        name.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        items.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        items.leftAnchor.constraint(equalTo: name.rightAnchor, constant: 2).isActive = true
        items.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -20).isActive = true
    }
    
    override func updateLayer() {
        layer!.backgroundColor = selected ? NSColor.controlAccentColor.cgColor : .clear
    }
}
