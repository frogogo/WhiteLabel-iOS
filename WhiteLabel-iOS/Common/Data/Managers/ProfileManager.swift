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

    APIConnector.shared.requestPATCH("user", params: params) { (isOK, response, errors) in
      if isOK {
        print("Успешно отправлены на сервер данные пользователя:")
      } else {
        print("Не удалось отправить данные пользователя на сервер")
      }
    }
  }
}
