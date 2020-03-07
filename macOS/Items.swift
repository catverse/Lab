import Balam
import AppKit

final class Items: NSView {
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
}
