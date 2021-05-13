//
//  BaseDataModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 13.05.2021.
//

import Foundation
import SwiftyJSON

class BaseDataModel {
  // MARK: - Static methods
  static func array<T: BaseDataModel>(withJSONDataArray jsonDataArray: [JSON]) -> [T] {
    var modelArray: [T] = []

    for jsonData in jsonDataArray {
      let newModel = T.init()
      newModel.update(with: jsonData)
      modelArray.append(newModel)
    }

    return modelArray
  }

  // MARK: - Lifecycle methods
  required init() {

  }

  // MARK: - Internal/public custom methods
  func update(with jsonData: JSON) {
    // default implementation does nothing
  }
}
