//
//  ProfileScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.09.2021.
//

import Foundation

class ProfileScreenViewModel: BaseViewModel {
  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()
    print("Надо отправить запрос на получение данных юзера")
  }

  // MARK: - Internal/public custom methods
  func logout() {
    AccountManager.shared.logout()
  }
}
