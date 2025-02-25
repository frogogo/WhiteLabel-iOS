//
//  ProductModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 08.07.2021.
//

import Foundation
import SwiftyJSON

class ProductModel: BaseDataModel {
  // MARK: - Properties
  var identifier = ""
  var photoURL = ""
  var name = ""
  var description = ""
  var specs = ""
  var price = 0.0
  var discountedPrice = 0.0

  // MARK: - Overridden methods
  override func update(with jsonData: JSON) {
    super.update(with: jsonData)

    identifier = jsonData["id"].stringValue
    photoURL = jsonData["image_url"].stringValue
    name = jsonData["name"].stringValue
    description = jsonData["description"].stringValue
    specs = jsonData["specs"].stringValue
    price = jsonData["price"].doubleValue
    discountedPrice = jsonData["discounted_price"].doubleValue
  }
}
