//
//  PromotionModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 13.05.2021.
//

import Foundation
import SwiftyJSON

class PromotionModel: BaseDataModel {
  // MARK: - Properties
  var name = ""
  var price = 0.0
  var discountedPrice = 0.0
  var photo = PhotoModel()
  var steps: [String] = []

  // MARK: - Overridden methods
  override func update(with jsonData: JSON) {
    super.update(with: jsonData)

    name = jsonData["name"].stringValue
    price = jsonData["price"].doubleValue
    discountedPrice = jsonData["discounted_price"].doubleValue
    photo.update(with: jsonData["photo"])

    if let stepsArray = jsonData["steps"].arrayObject as? [String] {
      steps = stepsArray
    }
  }
}
