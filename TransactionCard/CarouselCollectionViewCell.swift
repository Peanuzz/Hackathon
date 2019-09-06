import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    static let identifier = "CarouselCollectionViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      self.layer.borderColor = UIColor(red: 110.0/255.0, green: 80.0/255.0, blue: 140.0/255.0, alpha: 1.0).cgColor
    }
}
