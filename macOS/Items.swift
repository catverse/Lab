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
        var left = leftAnchor
        let sections = node.properties.map { $0.description.0 }.sorted().reduce(into: [String : Section]()) {
            $0[$1] = {
                addSubview($0)
                $0.topAnchor.constraint(equalTo: topAnchor).isActive = true
                $0.leftAnchor.constraint(equalTo: left, constant: 20).isActive = true
                left = $0.rightAnchor
                return $0
            } (Section($1))
        }
        if left != leftAnchor {
            rightAnchor.constraint(greaterThanOrEqualTo: left, constant: 20).isActive = true
        }
    }
}

private final class Section: NSView {
    required init?(coder: NSCoder) { nil }
    init(_ name: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let name = Label(name, .medium(14))
        name.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addSubview(name)
        
        let width = widthAnchor.constraint(equalToConstant: 0)
        width.priority = .defaultLow
        width.isActive = true
        
        widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        bottomAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        
        name.topAnchor.constraint(equalTo: topAnchor).isActive = true
        name.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        name.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -20).isActive = true
    }
}

private final class Item: NSView {
    
}
