import Foundation

struct Character {
  let imageName: String
  let name: String
  let balance: Int
  let type: CellType
}

enum CellType {
  case card
  case add
}


struct MRTModel {
  let imageIcon: String
  let name: String
  let date: String
  let time: String
  let income: Int
}

struct BTSModel {
  let imageIcon: String
  let name: String
  let date: String
  let time: String
  let income: Int
}
