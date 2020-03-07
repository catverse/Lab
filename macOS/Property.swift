import Balam
import Foundation

extension Property {
    var description: (Swift.String, Swift.String) {
        switch self {
        case let concrete as Property.Concrete:
            return (concrete.name, .init(describing: type(of: concrete)))
        default:
            return ("", "")
        }
    }
}
