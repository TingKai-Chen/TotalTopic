import UIKit

class Topic1Cell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
        
        self.layer.borderColor = UIColor.lightGray.cgColor
    
    }
    
}
