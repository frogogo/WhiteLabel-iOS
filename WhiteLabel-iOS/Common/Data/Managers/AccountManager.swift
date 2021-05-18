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

  var didUserSeeOnboarding: Bool {
    return UserDefaults.standard.bool(forKey: userDefaultsDidUserSeeOnboardingKey)
  }

  private let userDefaultsAuthTokenKey = "userAuthToken"
  private let userDefaultsRefreshTokenKey = "userRefreshToken"
  private let userDefaultsDidUserSeeOnboardingKey = "didUserSeeOnboarding"

  // MARK: - Internal/public custom methods
  func tryAutoLogin(onSuccess: @escaping () -> Void,
                    onFailure: @escaping () -> Void) {
    guard let savedToken = savedAuthToken(), savedToken != "" else {
      onFailure()
      return
    }
    print("\(type(of: self)): autologin OK (using token = \(savedToken)")
    APIConnector.shared.authToken = savedToken
    onSuccess()
  }

  func requestAuthCode(forPhoneNumber phoneNumberString: String,
                       onSuccess: @escaping (Int) -> Void,
                       onFailure: @escaping (String) -> Void) {

    let params = ["phone_number": phoneNumberString]
    APIConnector.shared.requestPOST("user", params: params, useAuth: false) {
      (isOK, response, errors) in

      if isOK {
        let refreshDelay = response["password_refresh_rate"].intValue
        onSuccess(refreshDelay)
      } else {
        print("\(type(of: self)): auth code request failed. Occured errors = \(errors)")
        let errorText = errors[0].description
        onFailure(errorText)
      }
    }
  }

  func auth(withPhoneNumber phoneNumber: String,
            andCode authCode: String,
            onSuccess: @escaping (_ isNewUser: Bool) -> Void,
            onFailure: @escaping (String) -> Void) {
    let params = ["phone_number": phoneNumber,
                  "password": authCode]
    APIConnector.shared.requestPOST("user_token", params: params, useAuth: false) {
      [weak self] (isOK, response, errors) in

      if isOK {
        let authToken = response["jwt"].stringValue
        let refreshToken = response["refresh_token"].stringValue
        let isNewUser = response["is_new"].boolValue

        APIConnector.shared.authToken = authToken
        self?.save(authToken: authToken, andRefreshToken: refreshToken)
        onSuccess(isNewUser)
      } else {
        print("\(type(of: self)): auth token request failed. Occured errors = \(errors)")
        let errorText = errors[0].description
        onFailure(errorText)
      }
    }
  }

  func registerUserDidSeeOnboarding() {
    UserDefaults.standard.setValue(true, forKey: userDefaultsDidUserSeeOnboardingKey)
    UserDefaults.standard.synchronize()
  }

  // MARK: - Private custom methods
  private func save(authToken authTokenString: String, andRefreshToken refreshTokenString: String) {
    // TODO: need to save tokens in database properly.
    // temporary solution – saving in UserDefaults
    print("Written auth token \(authTokenString)")
    print("Written refresh token \(refreshTokenString)")
    UserDefaults.standard.set(authTokenString, forKey: userDefaultsAuthTokenKey)
    UserDefaults.standard.set(refreshTokenString, forKey: userDefaultsRefreshTokenKey)
    UserDefaults.standard.synchronize()
  }

  private func savedAuthToken() -> String? {
    // TODO: need to retrieve token from database
    // temporary solution - retrieving from UserDefaults
    return UserDefaults.standard.string(forKey: userDefaultsAuthTokenKey)
  }

  private func savedRefreshToken() -> String? {
    // TODO: need to retrieve token from database
    // temporary solution - retrieving from UserDefaults
    return UserDefaults.standard.string(forKey: userDefaultsRefreshTokenKey)
  }
}
