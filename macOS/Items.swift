import Balam
import AppKit

final class Items: NSView {
    var node: Node! {
        didSet {
            render(node)
        }
    }
    
    private let numbers = NumberFormatter()
    private let dates = DateFormatter()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        dates.timeStyle = .short
        dates.dateStyle = .short
        
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
        let properties = node.properties.map { $0.description }.reduce(into: [String : String] ()) {
            $0[$1.0] = $1.1
        }
        let sections = properties.keys.sorted().reduce(into: [String : Section]()) {
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
                let item = make($0.1, type: properties[$0.0]!)
                addSubview(item)
                
                item.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
                item.leftAnchor.constraint(equalTo: sections[$0.0]!.leftAnchor).isActive = true
                item.rightAnchor.constraint(equalTo: sections[$0.0]!.rightAnchor).isActive = true
            }
            top += 30
        }
        heightAnchor.constraint(equalToConstant: top).isActive = true
    }
    
    private func make(_ value: Any, type: String) -> Item {
        switch type {
        case "Data": return data(Data((value as! String).utf8).count)
        case "Date": return calendar(.init(timeIntervalSince1970: value as! TimeInterval))
        case "String", "URL", "UUID": return text(value as! String)
        default: return numeric(value as? Double ?? 0)
        }
    }
    
    private func data(_ size: Int) -> Item {
        .init(ByteCountFormatter.string(fromByteCount: .init(size), countStyle: .file), align: .right)
    }
    
    private func numeric(_ value: Double) -> Item {
        .init(numbers.string(from: .init(value: value))!, align: .right)
    }
    
    private func calendar(_ date: Date) -> Item {
        .init(dates.string(from: date), align: .left)
    }
    
    private func text(_ value: String) -> Item {
        .init(value, align: .left)
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
    required init?(coder: NSCoder) { nil }
    init(_ value: String, align: NSTextAlignment) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let value = Label(value, .light(12))
        value.maximumNumberOfLines = 1
        value.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        value.lineBreakMode = .byTruncatingMiddle
        value.alignment = align
        addSubview(value)
        
        let width = widthAnchor.constraint(equalToConstant: 0)
        width.priority = .defaultLow
        width.isActive = true
        
        bottomAnchor.constraint(equalTo: value.bottomAnchor).isActive = true
        
        value.topAnchor.constraint(equalTo: topAnchor).isActive = true
        value.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        value.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
