import AppKit

final class Separator: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        
        let dots = CAShapeLayer()
        dots.fillColor = .clear
        dots.lineWidth = 1
        dots.lineDashPattern = [NSNumber(value: 3), NSNumber(value: 12)]
        layer!.addSublayer(dots)
        
        widthAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    override func layout() {
        super.layout()
        updateLayer()
    }
    
    override func updateLayer() {
        (layer!.sublayers!.first! as! CAShapeLayer).strokeColor = NSColor.highlightColor.cgColor
        (layer!.sublayers!.first! as! CAShapeLayer).path = {
            $0.move(to: .init(x: 0, y: 0))
            $0.addLine(to: .init(x: 0, y: bounds.maxY))
            return $0
        } (CGMutablePath())
    }
}
