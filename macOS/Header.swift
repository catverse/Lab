import AppKit

final class Header: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    override func updateLayer() {
        layer!.backgroundColor = NSColor.separatorColor.cgColor
    }
}
