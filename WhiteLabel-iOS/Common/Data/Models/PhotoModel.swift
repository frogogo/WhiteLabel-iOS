//
//  PhotoModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 13.05.2021.
//

import Foundation
import SwiftyJSON

class PhotoModel: BaseDataModel {
  // MARK: - Properties
  var largePhotoURL = ""
  var thumbPhotoURL = ""

  // MARK: - Overridden methods
  override func update(with jsonData: JSON) {
    super.update(with: jsonData)

    largePhotoURL = jsonData["large"].stringValue
    thumbPhotoURL = jsonData["thumb"].stringValue
  }
}
