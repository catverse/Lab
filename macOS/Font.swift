import AppKit

extension NSFont {
    class func light(_ size: CGFloat) -> NSFont {
        .systemFont(ofSize: size, weight: .light)
    }
    
    class func regular(_ size: CGFloat) -> NSFont {
        .systemFont(ofSize: size, weight: .regular)
    }
    
    class func medium(_ size: CGFloat) -> NSFont {
        .systemFont(ofSize: size, weight: .medium)
    }
    
    class func bold(_ size: CGFloat) -> NSFont {
        .systemFont(ofSize: size, weight: .bold)
    }
}
