//
//  CouponProgressModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 13.05.2021.
//

import Foundation
import SwiftyJSON

class CouponProgressModel: BaseDataModel {
  // MARK: - Properties
  var currentSum = 0.0
  var targetSum = 0.0

  // MARK: - Overridden methods
  override func update(with jsonData: JSON) {
    super.update(with: jsonData)

    currentSum = jsonData["current"].doubleValue
    targetSum = jsonData["target"].doubleValue
  }
}
