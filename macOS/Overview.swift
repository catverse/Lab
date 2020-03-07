import Balam
import AppKit

final class Overview: NSView {
    var node: Node! {
        didSet {
            render(node)
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let header = Header()
        addSubview(header)
        
        let title = Label(.key("Overview.properties"), .medium(16))
        title.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addSubview(title)
        
        let height = heightAnchor.constraint(equalToConstant: 0)
        height.priority = .defaultLow
        height.isActive = true

        bottomAnchor.constraint(greaterThanOrEqualTo: header.bottomAnchor).isActive = true
        rightAnchor.constraint(greaterThanOrEqualTo: title.rightAnchor).isActive = true
        
        header.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        header.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
    
    private func render(_ node: Node) {
        subviews.filter { $0 is Item }.forEach { $0.removeFromSuperview() }
        var top = topAnchor
        node.properties.map(item(_:)).sorted { $0.name.stringValue < $1.name.stringValue }.forEach {
            addSubview($0)
            rightAnchor.constraint(greaterThanOrEqualTo: $0.rightAnchor).isActive = true
            $0.topAnchor.constraint(equalTo: top, constant: top == topAnchor ? 60 : 15).isActive = true
            $0.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            top = $0.bottomAnchor
        }
        if top != topAnchor {
            bottomAnchor.constraint(equalTo: top, constant: 15).isActive = true
        }
    }
    
    private func item(_ property: Property) -> Item {
        { .init($0.0, type: $0.1) } (property.description)
    }
}

final private class Item: NSView {
    private(set) weak var name: Label!
    
    required init?(coder: NSCoder) { nil }
    init(_ name: String, type: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let name = Label(name, .regular(14))
        addSubview(name)
        self.name = name
        
        let type = Label(": " + type, .regular(12))
        type.textColor = .secondaryLabelColor
        addSubview(type)
        
        bottomAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: type.rightAnchor).isActive = true
        
        name.topAnchor.constraint(equalTo: topAnchor).isActive = true
        name.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        type.bottomAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        type.leftAnchor.constraint(equalTo: name.rightAnchor).isActive = true
    }
}
