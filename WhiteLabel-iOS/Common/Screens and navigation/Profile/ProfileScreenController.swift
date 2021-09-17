//
//  ProfileScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.09.2021.
//

import UIKit

class ProfileScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = ProfileScreenViewModel()

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
  }

  // MARK: - Handlers
  @IBAction func handleCloseButtonTap() {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func handleLogoutButtonTap() {
    print("Need to logout user")
    viewModel.logout()
  }
}
