
import Foundation

struct Book: Codable {
    
    let volumeInfo: BookInfo
    
    struct BookInfo: Codable {
        let title: String
        //let imageLinks: ImageLinks
        
        //struct ImageLinks: Codable {
            //let thumbnail: String
        //}
    }
}

struct BookResults: Codable {
    var items: [Book]
}



/*
struct Book: Codable {
    let title: String
    let imageLinks: ImageLinks
    
    struct ImageLinks: Codable {
        let smallThumbnail: String
    }
}

struct BookSearchResults: Codable {
    let items: VolumeInfo
    
    struct VolumeInfo: Codable {
        let volumeInfo: Book
    }
}
*/








/*
struct Book: Codable {
    let items: [Item]
}

struct Item: Codable {
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let imageLinks: ImageLinks
}

struct ImageLinks: Codable {
    let smallThumbnail: String
}
*/


