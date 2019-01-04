
import Foundation

struct Bookshelf: Codable {
    let title: String
    let id: Int
}

struct BookshelfResults: Codable {
    let items: [Bookshelf]
}


// NOTES
//
// https://www.googleapis.com/books/v1/mylibrary/bookshelves

// Retrieve a listing of all authenticated user's bookshelves.
// GET https://www.googleapis.com/books/v1/mylibrary/bookshelves?key=yourAPIKey
// Authorization: /* auth token here */
//
//
// Retrieve a listing of all the volumes on the authenticated user's bookshelf.
// https://www.googleapis.com/books/v1/mylibrary/bookshelves/shelf/volumes
// Replace the shelf path parameter with the ID of the bookshelf.
// Example:
// GET https://www.googleapis.com/books/v1/mylibrary/bookshelves/7/volumes?key=yourAPIKey
// Authorization: /* auth token here */
