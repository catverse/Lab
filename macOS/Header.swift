import AppKit

final class Header: NSView {
    private(set) weak var items: Label!
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let items = Label("", .light(12))
        items.textColor = .secondaryLabelColor
        addSubview(items)
        self.items = items
        
        let ribbon = Ribbon()
        addSubview(ribbon)
        
        let properties = Label(.key("Header.properties"), .medium(16))
        addSubview(properties)
        
        heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        items.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        items.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        ribbon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
        ribbon.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        ribbon.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        
        properties.topAnchor.constraint(equalTo: ribbon.bottomAnchor, constant: 15).isActive = true
        properties.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
    }
}

final private class Ribbon: NSView {
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
