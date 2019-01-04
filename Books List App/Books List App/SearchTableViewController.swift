
import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the search bar's delegate to the table view controller
        searchBarOutlet.delegate = self
        
        // Call the authorization function
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            
            // Completion: if there is an error, log it and return
            if let error = error {
                NSLog("Authorization failed: \(error)")
                return
            }
        }
    }
    
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookModel.shared.books.count
    }
    
    // Cell contents
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchBookTableViewCell.reuseIdentifier, for: indexPath) as! SearchBookTableViewCell
        
        // Get the search results associated with this row
        let searchResultBook = BookModel.shared.books[indexPath.row]
        
        // Configure the cell
        // Pass the search result to the cell
        cell.book = searchResultBook
        
        return cell
    }
    
    // MARK: - UI Search Bar
    
    // Tells the delegate that the search button was tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Grab text, make sure you have text, make sure it's not empty
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        
        // Run the search
        BookModel.shared.searchForBooks(with: searchTerm) { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    // Tell the table view that it needs to reload the data
                    // Reload when our model sets its books to the results
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
