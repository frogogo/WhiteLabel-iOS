//
//  ProfileScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.09.2021.
//

import Foundation

protocol ProfileScreenViewModelDelegate: AnyObject {
  func occuredError(withText errorText: String)
}

class ProfileScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: ProfileScreenViewModelDelegate?

  let logoutButtonTitle = LocalizedString(forKey: "profile_screen.logout_button.title")
  let nameString = Box(value: "")
  let phoneString = Box(value: "")
  let emailString = Box(value: "")
  let versionString = Box(value: "")

  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    ProfileManager.shared.loadCurrentUser { [weak self] loadedUser in
      guard let self = self else { return }
      self.nameString.value = loadedUser.name
      self.phoneString.value = loadedUser.phoneNumber
      self.emailString.value = loadedUser.email
      self.versionString.value = self.appVersionToDisplay()

    } onFailure: { [weak self] error in
      self?.delegate?.occuredError(withText: error)
    }
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
