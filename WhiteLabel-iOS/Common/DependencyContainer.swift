//
//  DependencyContainer.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 26.05.2021.
//

import Foundation

/**
 This class keeps all implementation dependencies
 Call setupDependencies func for
 */
class DependencyContainer {
  // MARK: - Static properties
  private static let apiConnector = APIConnector()

  // MARK: - Internal/public static methods
  /**
   This method must be called in first line of entry point of the app
   */
  static func setupDependencies() {
    setupAPIConnector()
    setupDataManagers()
  }

  // MARK: - Private static methods
  private static func setupAPIConnector() {
    apiConnector.authenticator = AccountManager.shared
  }

  private static func setupDataManagers() {
    AccountManager.shared.apiConnector = apiConnector
    HomeManager.shared.apiConnector = apiConnector
    ProfileManager.shared.apiConnector = apiConnector
    ReceiptManager.shared.apiConnector = apiConnector
    ProductManager.shared.apiConnector = apiConnector
  }
}
