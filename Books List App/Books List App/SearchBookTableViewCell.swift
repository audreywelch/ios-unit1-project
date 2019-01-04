
import UIKit

class SearchBookTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "booksearchcell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var reviewTextField: UITextField!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    var book: Book? {
        didSet {
            updateViews()
        }
    }
    
    // Cell sets itself up
    private func updateViews() {
        
        // Check to make sure there is a book
        guard let book = book else { return }
        
        // Set the contents
        titleLabel.text = book.title
        
        // Get a url, try to load image data from that URL
        guard let url = URL(string: book.imageLinks.smallThumbnail), let imageData = try? Data(contentsOf: url) else { return }
        
        bookImage.image = UIImage(data: imageData)
    }
    
    
}
