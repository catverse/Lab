import Foundation

struct Bookmark: Codable, Identifiable {
    var edited: Date
    let id: UUID
    let url: URL
    let access: Data
    
    init(_ url: URL) {
        id = .init()
        edited = .init()
        access = try! url.bookmarkData(options: .withSecurityScope)
        self.url = url
    }
}
