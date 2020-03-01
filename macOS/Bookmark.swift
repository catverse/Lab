import Foundation

struct Bookmark: Codable, Identifiable {
    var edited: Date
    let id: URL
    let access: Data
    
    init(_ url: URL) {
        id = url
        edited = .init()
        access = try! url.bookmarkData(options: .withSecurityScope)
    }
}
