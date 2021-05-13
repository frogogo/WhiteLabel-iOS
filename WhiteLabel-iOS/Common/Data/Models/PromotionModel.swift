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
  var photo = PhotoModel()
  var name = ""
  var steps: [String] = []

  // MARK: - Overridden methods
  override func update(with jsonData: JSON) {
    super.update(with: jsonData)

    name = jsonData["name"].stringValue
    photo.update(with: jsonData["photo"])

    if let stepsArray = jsonData["steps"].arrayObject as? [String] {
      steps = stepsArray
    }
  }
}
