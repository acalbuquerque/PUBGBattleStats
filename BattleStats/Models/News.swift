import Foundation

struct News: Codable {

    let id: Int
    let type: String
    let title: String
    let subtitle: String?
    let imageURL: String
    let newsURL: String
}

extension News: Equatable {
    
    static func ==(lhs: News, rhs: News) -> Bool {
        return lhs.id == rhs.id &&
            lhs.type == rhs.type &&
            lhs.title == rhs.title &&
            lhs.subtitle == rhs.subtitle &&
            lhs.imageURL == rhs.imageURL &&
            lhs.newsURL == rhs.newsURL
    }
    
    static func makeEmpty() -> News {
        return News(id: 0, type: "",  title: "", subtitle: "", imageURL: "", newsURL: "")
    }
}
