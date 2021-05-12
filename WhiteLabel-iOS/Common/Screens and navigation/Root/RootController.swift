//
//  RootController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 16.04.2021.
//

import UIKit

class RootController: UIViewController {
  // MARK: - Lifecycle methods
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tryAutoLogin()
  }

  // MARK: - Private custom methods
  private func tryAutoLogin() {
    AccountManager.shared.tryAutoLogin { [weak self] in
      self?.performSegue(withIdentifier: "RootToHomeSegue", sender: nil)
    } onFailure: { [weak self] in
      self?.performSegue(withIdentifier: "RootToAuthSegue", sender: nil)
    }
  }
}
