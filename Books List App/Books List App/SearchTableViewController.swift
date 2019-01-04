
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
    
    
    
}
