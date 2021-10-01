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

  @IBOutlet private var logoutButton: UIButton!
  @IBOutlet private var nameLabel: UILabel!
  @IBOutlet private var phoneLabel: UILabel!
  @IBOutlet private var emailLabel: UILabel!
  @IBOutlet private var versionLabel: UILabel!

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
  }

  override func addBindings() {
    super.addBindings()

    viewModel.nameString.bind { [weak self] nameString in
      self?.nameLabel.text = nameString
    }
    viewModel.phoneString.bind { [weak self] phoneString in
      self?.phoneLabel.text = phoneString
    }
    viewModel.emailString.bind { [weak self] emailString in
      self?.emailLabel.text = emailString
    }
    viewModel.versionString.bind { [weak self] versionString in
      self?.versionLabel.text = versionString
    }
  }

  override func setupStaticContentForDisplay() {
    super.setupStaticContentForDisplay()
    logoutButton.setTitle(viewModel.logoutButtonTitle, for: .normal)
  }

  // MARK: - Handlers
  @IBAction func handleCloseButtonTap() {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func handleLogoutButtonTap() {
    viewModel.logout()
  }
}
