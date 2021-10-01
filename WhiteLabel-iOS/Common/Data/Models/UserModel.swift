//
//  UserModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.09.2021.
//

import Foundation
import SwiftyJSON

class UserModel: BaseDataModel {
  // MARK: - Properties
  var name = ""
  var phoneNumber = ""
  var email = ""
  
  // MARK: - Overridden methods
  override func update(with jsonData: JSON) {
    super.update(with: jsonData)

    name = jsonData["first_name"].stringValue
    phoneNumber = jsonData["phone_number"].stringValue
    email = jsonData["email"].stringValue
  }
}
