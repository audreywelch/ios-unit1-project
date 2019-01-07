
import UIKit

class BookshelfModel {
    
    private(set) var bookshelves: [Bookshelf] = []
    
    // Singleton
    static let sharedBookshelf = BookshelfModel()
    private init () {}
    
    func saveButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.setTitle("✚", for: .normal)
            sender.isSelected = false
        } else {
            sender.setTitle("✓", for: .normal)
            sender.isSelected = true
        }
    }
    
    
    
    
}
