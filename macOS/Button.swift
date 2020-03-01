import AppKit

final class Button: Control {
    required init?(coder: NSCoder) { nil }
    init(_ title: String, _ target: AnyObject, _ action: Selector) {
        super.init(target, action)
        wantsLayer = true
        layer!.cornerRadius = 4
        
        let label = Label(title, .medium(12))
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addSubview(label)
        
        heightAnchor.constraint(equalToConstant: 30).isActive = true
        leftAnchor.constraint(equalTo: label.leftAnchor, constant: -10).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 10).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func updateLayer() {
        layer!.backgroundColor = NSColor.controlAccentColor.cgColor
    }
}
