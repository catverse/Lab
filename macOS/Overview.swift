import Balam
import AppKit

final class Overview: Scroll {
    var node: Node! {
        didSet {
            header.items.stringValue = formatter.string(from: .init(value: node.items.count))! + .key(node.items.count == 1 ? "Overview.item" : "Overview.items")
            isHidden = false
            render(node)
        }
    }
    
    private weak var header: Header!
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        isHidden = true
        
        let header = Header()
        add(header)
        self.header = header
        
        bottom.constraint(greaterThanOrEqualTo: header.bottomAnchor).isActive = true
        
        header.topAnchor.constraint(equalTo: top).isActive = true
        header.leftAnchor.constraint(equalTo: left).isActive = true
        header.rightAnchor.constraint(equalTo: right).isActive = true
    }
    
    private func render(_ node: Node) {
        views.compactMap { $0 as? Item }.forEach { $0.removeFromSuperview() }
        var top = header.bottomAnchor
        node.properties.map(item(_:)).forEach {
            add($0)
            
            $0.topAnchor.constraint(equalTo: top, constant: 15).isActive = true
            $0.leftAnchor.constraint(equalTo: left, constant: 30).isActive = true
            $0.rightAnchor.constraint(equalTo: right, constant: -30).isActive = true
            top = $0.bottomAnchor
        }
        bottom.constraint(equalTo: top, constant: 15).isActive = true
    }
    
    private func item(_ property: Property) -> Item {
        switch property {
        case let concrete as Property.Concrete:
            return .init(concrete.name, type: String(describing: type(of: concrete)))
        default:
            return .init("", type: "")
        }
    }
}

final private class Item: NSView {
    required init?(coder: NSCoder) { nil }
    init(_ name: String, type: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let name = Label(name, .regular(14))
        addSubview(name)
        
        let type = Label(": " + type, .regular(12))
        type.textColor = .secondaryLabelColor
        addSubview(type)
        
        bottomAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        
        name.topAnchor.constraint(equalTo: topAnchor).isActive = true
        name.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        type.bottomAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        type.leftAnchor.constraint(equalTo: name.rightAnchor, constant: 2).isActive = true
    }
}
