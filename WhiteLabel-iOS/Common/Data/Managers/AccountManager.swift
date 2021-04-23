//
//  AccountManager.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 22.04.2021.
//

import Foundation

class AccountManager: BaseDataManager {
  // MARK: - Properties
  static let shared = AccountManager()

  // MARK: - Internal/public custom methods
  func auth(withPhoneNumber phoneNumberString: String,
            onSuccess: @escaping () -> Void,
            onFailure: @escaping () -> Void) {

    let params = ["phone_number": phoneNumberString]
    APIConnector.shared.requestPOST("user", params: params, useAuth: false) {
      (isOK, responseData, errors) in
      if isOK {
        print("")
        onSuccess()
      } else {
        onFailure()
      }
    }
  }
}
