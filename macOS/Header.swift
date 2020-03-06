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
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        items.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        items.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
    }
}
