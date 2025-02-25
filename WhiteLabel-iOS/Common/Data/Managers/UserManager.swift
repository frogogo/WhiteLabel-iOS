//
//  UserManager.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 28.04.2021.
//

import Foundation

class UserManager: BaseDataManager {
  // MARK: - Properties
  static let shared = UserManager()

  // MARK: - Internal/public custom methods
  func loadCurrentUser(onSuccess: @escaping (UserModel) -> Void,
                       onFailure: @escaping (String) -> Void) {

    apiConnector.requestGET("user") { (isOK, response, errors) in
      if isOK {
        let parsedUser = UserModel()
        parsedUser.update(with: response)
        onSuccess(parsedUser)
      } else {
        print("\(type(of: self)): current user data load failed. Occured errors = \(errors)")
        let errorText = errors[0].description
        onFailure(errorText)
      }
    }
  }

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
