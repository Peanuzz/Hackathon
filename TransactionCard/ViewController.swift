//
//  ViewController.swift
//  TransactionCard
//
//  Created by Peanuz on 6/9/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var balanceLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var tableView: UITableView!
  
  var items = [Character]()
  var itemsMRT = [MRTModel]()
  var itemsBTS = [BTSModel]()
  var name: String?
  var count: Int = 0
  
  var currentPage: Int = 0 {
    didSet {
      let character = items[self.currentPage]
      self.balanceLabel.text = ("Balance: ฿\(character.balance)")
      self.name = character.name
      if character.name == "mrt" {
        let itemMRT = itemsMRT[self.currentPage]
        (tableView.dataSource as? TransactionTableViewCell)?.cardNameLabel.text = itemMRT.name
        (tableView.dataSource as? TransactionTableViewCell)?.dateLabel.text = itemMRT.date
        (tableView.dataSource as? TransactionTableViewCell)?.timeLabel.text = itemMRT.time
        (tableView.dataSource as? TransactionTableViewCell)?.incomeLabel.text = "+฿\(itemMRT.income)"
        tableView.reloadData()
      } else if character.name == "bts" {
        let itemBTS = itemsBTS[self.currentPage]
        (tableView.dataSource as? TransactionTableViewCell)?.cardNameLabel.text = itemBTS.name
        (tableView.dataSource as? TransactionTableViewCell)?.dateLabel.text = itemBTS.date
        (tableView.dataSource as? TransactionTableViewCell)?.timeLabel.text = itemBTS.time
        (tableView.dataSource as? TransactionTableViewCell)?.incomeLabel.text = "+฿\(itemBTS.income)"
        tableView.reloadData()
      } else if character.name == "addcard" {
        tableView.reloadData()
      }
    }
  }
  
  private var pageSize: CGSize {
    let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
    var pageSize = layout.itemSize
    if layout.scrollDirection == .horizontal {
      pageSize.width += layout.minimumLineSpacing
    } else {
      pageSize.height += layout.minimumLineSpacing
    }
    return pageSize
  }
  
  private var orientation: UIDeviceOrientation {
    return UIDevice.current.orientation
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let nib = UINib(nibName: "CustomCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "CustomCell")
    self.setupLayout()
    self.items = self.createItems()
    self.itemsMRT = self.createItemsMRT()
    self.itemsBTS = self.createItemsBTS()
    self.currentPage = 0
    
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    
  }
  
  private func setupLayout() {
    let layout = UPCarouselFlowLayout()
    layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 50)
    layout.itemSize = CGSize(width: 300, height: 200)
    collectionView.collectionViewLayout = layout
  }
  
  private func createItems() -> [Character] {
    let characters = [
      Character(imageName: "", name: "addcard", balance: 0, type: .add),
    ]
    pageControl.numberOfPages = characters.count
    return characters
  }
  
  private func createItemsMRT() -> [MRTModel] {
    let mrtDetails = [
      MRTModel(imageIcon: "mrticon", name: "MRT", date: "20/10/19", time: "01.30 PM", income: 1000),
      MRTModel(imageIcon: "mrticon", name: "MRT", date: "20/10/19", time: "9.30 PM", income: 100),
      MRTModel(imageIcon: "mrticon", name: "MRT", date: "20/10/19", time: "03.30 PM", income: 300),
      MRTModel(imageIcon: "mrticon", name: "MRT", date: "20/10/19", time: "08.30 AM", income: 400),
      MRTModel(imageIcon: "mrticon", name: "MRT", date: "20/10/19", time: "7.30 PM", income: 500)
    ]
    return mrtDetails
  }
  
  private func createItemsBTS() -> [BTSModel] {
    let btsDetails = [
      BTSModel(imageIcon: "btsicon", name: "BTS", date: "20/10/19", time: "06.30 AM", income: 200),
      BTSModel(imageIcon: "btsicon", name: "BTS", date: "20/10/19", time: "09.30 PM", income: 500),
      BTSModel(imageIcon: "btsicon", name: "BTS", date: "20/10/19", time: "10.30 AM", income: 100),
      BTSModel(imageIcon: "btsicon", name: "BTS", date: "20/10/19", time: "03.30 PM", income: 150),
      BTSModel(imageIcon: "btsicon", name: "BTS", date: "20/10/19", time: "11.30 AM", income: 400)
    ]
    return btsDetails
  }
  
  
  @objc private func rotationDidChange() {
    guard !orientation.isFlat else { return }
    let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
    let direction: UICollectionView.ScrollDirection = orientation.isPortrait ? .horizontal : .vertical
    layout.scrollDirection = direction
    if currentPage > 0 {
      let indexPath = IndexPath(item: currentPage, section: 0)
      let scrollPosition: UICollectionView.ScrollPosition = orientation.isPortrait ? .centeredHorizontally : .centeredVertically
      self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
    }
  }
  
  // MARK: - Card Collection Delegate & DataSource
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let character = items[(indexPath as NSIndexPath).row]
    switch character.type {
    case .card:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as? CarouselCollectionViewCell else {
        return UICollectionViewCell()
      }
      cell.image.image = UIImage(named: character.imageName)
      self.name = character.name
      return cell
    case .add:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCardCollectionViewCell.identifier, for: indexPath) as? AddCardCollectionViewCell else {
        return UICollectionViewCell()
      }
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let character = items[(indexPath as NSIndexPath).row]
    let alert = UIAlertController(title: character.name, message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  
  // MARK: - UIScrollViewDelegate
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
    let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
    let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
    currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    pageControl.currentPage = Int(currentPage)
  }
  
  @IBAction func addCard() {
    if count % 2 == 0 {
      let characters = [Character(imageName: "rabbit1", name: "bts", balance: 500, type: .card)]
      items.append(contentsOf: characters)
      count += 1
    } else if count % 2 == 1 {
      let characters = [Character(imageName: "mrt1", name: "mrt", balance: 1000, type: .card)]
      items.append(contentsOf: characters)
      count += 1
    }
    collectionView.reloadData()
    pageControl.numberOfPages = items.count
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemsMRT.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? TransactionTableViewCell else {
      return UITableViewCell()
    }
    if name == "addcard" {
      return UITableViewCell()
    } else if name == "mrt" {
      let itemMRT = itemsMRT[indexPath.item]
      cell.configCellMRT(items: itemMRT)
    } else if name == "bts" {
      let itemBTS = itemsBTS[indexPath.item]
      cell.configCellBTS(items: itemBTS)
    }
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

