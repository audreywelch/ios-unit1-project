// https://www.googleapis.com/books/v1/volumes?q=search+terms
// https://www.googleapis.com/books/v1/volumes?q=homegoing

import Foundation

class BookModel {
    
    private(set) var books: [Book] = []
    
    // Singleton
    static let shared = BookModel()
    private init () {}
    
    let baseURL = URL(string: "https://www.googleapis.com/books/v1")!
    
    // Function that can be called from table view controller that takes in a search term and sets self.books to the result of the search.
    
    func searchForBooks(with searchTerm: String, completion: @escaping (Error?) -> Void) {
        
        // Build up the API end point
        let volumesURL = baseURL.appendingPathComponent("volumes")
        
        // Decompose into components
        // Search query requires query items/components
        var components = URLComponents(url: volumesURL, resolvingAgainstBaseURL: true)
        
        let searchQueryItem = URLQueryItem(name: "q", value: searchTerm.lowercased())
        
        // Set up query item
        components?.queryItems = [searchQueryItem]
        
        // Create URL out of components by recomposing
        guard let requestURL = components?.url else {
            NSLog("Couldn't make requestURL from \(components)")
            completion(NSError())
            return
        }
        print(requestURL)
        
        // Make GET request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        // Reach out to the network
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            // Check to see if there is an error
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            // Unwrap data because it will be optional
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            // Decode the data
            let jsonDecoder = JSONDecoder()
            
            do {
                // Variable for decoded results
                let books = try jsonDecoder.decode(BookResults.self, from: data)
                    //let books = try jsonDecoder.decode(BookSearchResults.self, from: data)
                // Set our internal array of books to be the decoded results
                self.books = books.items
                print(books)
                completion(nil)
                return
            } catch {
                NSLog("Unable to decode data: \(error)")
                completion(error)
                return
            }
        }
        .resume()
    }
    
    
    //func searchForBookshelves
}
