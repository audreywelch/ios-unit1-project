

import UIKit

class SaveTableViewController: UITableViewController {
    
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookshelfModel.sharedBookshelf.bookshelves.count
    }
    
    // Cell contents
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: SaveBookTableViewCell.reuseIdentifier, for: indexPath) as! SaveBookTableViewCell
        
        // Get the search results associated with this row
        let searchResultBookshelf = BookshelfModel.sharedBookshelf.bookshelves[indexPath.row]
        
        // Configure the cell
        // Pass the search result to the cell
        cell.bookshelf = searchResultBookshelf
        
        return cell
    }
    
}
