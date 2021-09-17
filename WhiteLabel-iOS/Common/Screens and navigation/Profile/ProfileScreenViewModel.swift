//
//  ProfileScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.09.2021.
//

import Foundation

class ProfileScreenViewModel: BaseViewModel {
  // MARK: - Properties
  let logoutButtonTitle = LocalizedString(forKey: "profile_screen.logout_button.title")
  let versionString = Box(value: "")
  let nameString = Box(value: "")
  let phoneString = Box(value: "")
  let emailString = Box(value: "")

  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()
    print("Надо отправить запрос на получение данных юзера")

    versionString.value = appVersionToDisplay()
  }

  // MARK: - Private custom methods
  private func appVersionToDisplay() -> String {
    guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "" }
    return LocalizedString(forKey: "profile_screen.version_prefix") + " " + appVersion
  }

  // MARK: - Internal/public custom methods
  func logout() {
    AccountManager.shared.logout()
  }
}
