//
//  AccountManager.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 22.04.2021.
//

import Foundation
import SwiftyJSON

class AccountManager: BaseDataManager {
  // MARK: - Properties
  static let shared = AccountManager()

  var didUserSeeOnboarding: Bool {
    return UserDefaults.standard.bool(forKey: userDefaultsDidUserSeeOnboardingKey)
  }

  private let userDefaultsAuthTokenKey = "userAuthToken"
  private let userDefaultsRefreshTokenKey = "userRefreshToken"
  private let userDefaultsAuthTokenCreationDateKey = "userAuthTokenCreationDate"
  private let userDefaultsDidUserSeeOnboardingKey = "didUserSeeOnboarding"

  private let authTokenLifetimeInSeconds: TimeInterval = 2 * 24 * 60 * 60

  private var authTokenString: String?
  private var authTokenCreationDate: Date?

  // MARK: - Internal/public custom methods
  func tryAutoLogin() {
    if let savedToken = savedAuthToken(), savedToken != "" {
      authTokenString = savedToken
      postNotification(withName: .autoLoginOK)
      return
    }

    tryToRefreshAuthToken { [weak self] (isRefreshedOK) in
      if isRefreshedOK {
        self?.postNotification(withName: .autoLoginOK)
      }
    }
  }

  func requestAuthCode(forPhoneNumber phoneNumberString: String,
                       onSuccess: @escaping (Int) -> Void,
                       onFailure: @escaping (String) -> Void) {

    let params = ["phone_number": phoneNumberString]
    apiConnector.requestPOST("user", params: params, useAuth: false) {
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
    apiConnector.requestPOST("user_token", params: params, useAuth: false) {
      [weak self] (isOK, response, errors) in

      if isOK {
        let isNewUser = response["is_new"].boolValue
        self?.parseAndSaveTokens(from: response)
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

  func checkAuthTokenDateAndRefreshIfNeeded() {
    authTokenCreationDate = savedAuthTokenCreationDate()

    var needToRefresh = false
    if authTokenCreationDate != nil {
      let tokenExpiringDate = authTokenCreationDate!.addingTimeInterval(authTokenLifetimeInSeconds)
      needToRefresh = Date() > tokenExpiringDate
    }

    guard needToRefresh else { return }
    tryToRefreshAuthToken { (isRefreshedOK) in
      print("\(type(of: self)): Token refresh \(isRefreshedOK ? "OK" : "FAILED")")
    }
  }

  func logout() {
    deleteTokens()
    deleteOnboardingSeenMark()
    postNotification(withName: .authorizationRequired)
  }

  // MARK: - Private custom methods
  private func tryToRefreshAuthToken(_ onComplete: ((Bool) -> Void)? = nil) {
    guard let retrievedRefreshToken = savedRefreshToken() else {
      postNotification(withName: .authorizationRequired)
      onComplete?(false)
      return
    }

    let params = ["refresh_token": retrievedRefreshToken]
    apiConnector.requestPOST("user_token", params: params, useAuth: false) {
      [weak self] (isOK, response, errors) in

      if isOK {
        self?.parseAndSaveTokens(from: response)
        onComplete?(true)
      } else {
        self?.postNotification(withName: .authorizationRequired)
        print("\(type(of: self)): auth token refresh failed. Occured errors = \(errors)")
        onComplete?(false)
      }
    }
  }

  private func parseAndSaveTokens(from tokensPayload: JSON) {
    let authToken = tokensPayload["jwt"].stringValue
    let refreshToken = tokensPayload["refresh_token"].stringValue
    authTokenString = authToken
    authTokenCreationDate = Date()

    save(authToken: authToken, andRefreshToken: refreshToken)
  }

  private func save(authToken authTokenString: String, andRefreshToken refreshTokenString: String) {
    // TODO: need to save tokens in database properly.
    // temporary solution – saving in UserDefaults
    UserDefaults.standard.set(authTokenString, forKey: userDefaultsAuthTokenKey)
    UserDefaults.standard.set(refreshTokenString, forKey: userDefaultsRefreshTokenKey)
    UserDefaults.standard.set(authTokenCreationDate, forKey: userDefaultsAuthTokenCreationDateKey)
    UserDefaults.standard.synchronize()
  }

  private func savedAuthToken() -> String? {
    // TODO: need to retrieve token from database
    // temporary solution - retrieving from UserDefaults
    return UserDefaults.standard.string(forKey: userDefaultsAuthTokenKey)
  }

  private func savedAuthTokenCreationDate() -> Date? {
    // TODO: need to retrieve token creation date from database
    // temporary solution - retrieving from UserDefaults
    return UserDefaults.standard.object(forKey: userDefaultsAuthTokenCreationDateKey) as? Date
  }

  private func savedRefreshToken() -> String? {
    // TODO: need to retrieve token from database
    // temporary solution - retrieving from UserDefaults
    return UserDefaults.standard.string(forKey: userDefaultsRefreshTokenKey)
  }

  private func deleteTokens() {
    UserDefaults.standard.set(nil, forKey: userDefaultsAuthTokenKey)
    UserDefaults.standard.set(nil, forKey: userDefaultsRefreshTokenKey)
    UserDefaults.standard.set(nil, forKey: userDefaultsAuthTokenCreationDateKey)
    UserDefaults.standard.synchronize()
  }

  private func deleteOnboardingSeenMark() {
    UserDefaults.standard.setValue(false, forKey: userDefaultsDidUserSeeOnboardingKey)
    UserDefaults.standard.synchronize()
  }
}

// MARK: - API Authenticator methods
extension AccountManager: APIAuthenticator {
  // MARK: Properties
  var authToken: String? {
    return authTokenString
  }

  // MARK: Methods
  func refreshAuthToken(_ onComplete: @escaping (Bool) -> Void) {
    tryToRefreshAuthToken(onComplete)
  }
}
