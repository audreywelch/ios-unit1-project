
import Foundation

struct Book: Codable {
    
    let title: String
    //let authors: [String]
    let imageLinks: ImageLinks
    
    struct ImageLinks: Codable {
        let smallThumbnail: String
    }
}

struct BookResults: Codable {
    var items: [VolumeInfo]
    
    struct VolumeInfo: Codable {
        let volumeInfo: [Book]
    }
    
}
