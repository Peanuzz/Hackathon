import UIKit

class TransactionTableViewCell: UITableViewCell {
  
  static let CellIdentifier: String = "CustomCell"
  
  @IBOutlet weak var cardNameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var incomeLabel: UILabel!
  @IBOutlet weak var imageCard: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
      self.imageCard.layer.cornerRadius = self.imageCard.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
  
  func configCellMRT(items: MRTModel) {
    cardNameLabel.text = items.name.uppercased()
    dateLabel.text = items.date
    timeLabel.text = items.time
    incomeLabel.text = "+$\(items.income)"
//    imageCard.image = UIImage(named: items.imageIcon)
  }
  
  func configCellBTS(items: BTSModel) {
    cardNameLabel.text = items.name.uppercased()
    dateLabel.text = items.date
    timeLabel.text = items.time
    incomeLabel.text = "+$\(items.income)"
//    imageCard.image = UIImage(named: items.imageIcon)
  }


}
