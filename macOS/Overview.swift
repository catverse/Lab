import Balam
import AppKit

final class Overview: Scroll {
    var node: Node! {
        didSet {
            header.items.stringValue = formatter.string(from: .init(value: node.items.count))! + .key(node.items.count == 1 ? "Overview.item" : "Overview.items")
        }
    }
    
    private weak var header: Header!
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        
        let header = Header()
        add(header)
        self.header = header
        
        bottom.constraint(greaterThanOrEqualTo: header.bottomAnchor).isActive = true
        
        header.topAnchor.constraint(equalTo: top).isActive = true
        header.leftAnchor.constraint(equalTo: left).isActive = true
        header.rightAnchor.constraint(equalTo: right).isActive = true
    }
}
