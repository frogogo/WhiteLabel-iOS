//
//  ProfileManager.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 28.04.2021.
//

import Foundation

class ProfileManager: BaseDataManager {
  // MARK: - Properties
  static let shared = ProfileManager()

  // MARK: - Internal/public custom methods
  func update(name nameString: String? = nil,
              email emailString: String? = nil,
              onSuccess: @escaping () -> Void,
              onFailure: @escaping (String) -> Void) {

    var params: [String: String] = [:]
    if nameString != nil {
      params["first_name"] = nameString
    }
    if emailString != nil {
      params["email"] = emailString
    }
    guard params.count > 0 else {
      onFailure("\(type(of: self)): не задано ни имя, ни email!")
      return
    }

    apiConnector.requestPATCH("user", params: params) { (isOK, response, errors) in
      if isOK {
        print("\(type(of: self)): profile data sent")
        onSuccess()
      } else {
        print("\(type(of: self)): home data load failed. Occured errors = \(errors)")
        let errorText = errors[0].description
        onFailure(errorText)
      }
    }
  }
}
