

import UIKit

class SaveBookTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "booksavecell"
    
    @IBOutlet weak var bookshelfNameLabel: UILabel!
    
    @IBOutlet weak var addToBookshelfOutlet: UIButton!
    
    @IBAction func addToBookshelfAction(_ sender: Any) {
        
        // Call the function in the model to toggle emojis
        // Command-Control-Spacebar = Emoji options
        BookshelfModel.sharedBookshelf.saveButtonTapped(addToBookshelfOutlet)
        
        // When tapped, add the book from the tapped SearchBookTableViewCell to the Bookshelf that is being tapped
        
        
    }
    
    var bookshelf: Bookshelf? {
        didSet {
            updateViews()
        }
    }
    
    // Cell sets itself up
    private func updateViews() {
        
        // Check to make sure there is a bookshelf
        guard let bookshelf = bookshelf else { return }
        
        // Set the contents
        bookshelfNameLabel.text = bookshelf.title
        

        
    }
}
