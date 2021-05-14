//
//  CouponModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 13.05.2021.
//

import Foundation
import SwiftyJSON

class CouponModel: BaseDataModel {
  // MARK: - Properties
  var identifier = ""
  var code = 0

  // MARK: - Overridden methods
  override func update(with jsonData: JSON) {
    super.update(with: jsonData)

    identifier = jsonData["id"].stringValue
    code = jsonData["code"].intValue
  }
}
