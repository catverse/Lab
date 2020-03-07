import Balam
import AppKit

final class Items: NSView {
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
        
        let height = heightAnchor.constraint(equalToConstant: 0)
        height.priority = .defaultLow
        height.isActive = true

        bottomAnchor.constraint(greaterThanOrEqualTo: header.bottomAnchor).isActive = true
        
        header.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        header.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    private func render(_ node: Node) {
        subviews.filter { !($0 is Header) }.forEach { $0.removeFromSuperview() }
        guard !node.properties.isEmpty else { return }
        var left = leftAnchor
        let sections = node.properties.map { $0.description.0 }.sorted().reduce(into: [String : Section]()) {
            $0[$1] = {
                addSubview($0)
                $0.topAnchor.constraint(equalTo: topAnchor).isActive = true
                $0.leftAnchor.constraint(equalTo: left, constant: left == leftAnchor ? 0 : 40).isActive = true
                left = $0.rightAnchor
                return $0
            } (Section($1))
        }
        rightAnchor.constraint(greaterThanOrEqualTo: left, constant: 40).isActive = true
        
        var top = CGFloat(50)
        node.items.map { try! JSONSerialization.jsonObject(with: $0) as! [String : Any] }.forEach {
            $0.forEach {
                let item = make($0.1)
                addSubview(item)
                
                item.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
                item.leftAnchor.constraint(equalTo: sections[$0.0]!.leftAnchor).isActive = true
                item.rightAnchor.constraint(lessThanOrEqualTo: sections[$0.0]!.rightAnchor).isActive = true
            }
            top += 30
        }
        heightAnchor.constraint(equalToConstant: top).isActive = true
    }
    
    private func make(_ value: Any) -> Item {
        .init("\(value)")
    }
}

private final class Section: NSView {
    required init?(coder: NSCoder) { nil }
    init(_ name: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let name = Label(name, .medium(16))
        name.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addSubview(name)
        
        let width = widthAnchor.constraint(equalToConstant: 0)
        width.priority = .defaultLow
        width.isActive = true
        
        widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        bottomAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        
        name.topAnchor.constraint(equalTo: topAnchor).isActive = true
        name.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        name.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor).isActive = true
    }
}

private final class Item: NSView {
    private(set) weak var value: Label!
    
    required init?(coder: NSCoder) { nil }
    init(_ value: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let value = Label(value, .light(12))
        value.maximumNumberOfLines = 1
        value.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        value.lineBreakMode = .byTruncatingMiddle
        addSubview(value)
        
        let width = widthAnchor.constraint(equalToConstant: 0)
        width.priority = .defaultLow
        width.isActive = true
        
        bottomAnchor.constraint(equalTo: value.bottomAnchor).isActive = true
        
        value.topAnchor.constraint(equalTo: topAnchor).isActive = true
        value.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        value.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor).isActive = true
    }
}
