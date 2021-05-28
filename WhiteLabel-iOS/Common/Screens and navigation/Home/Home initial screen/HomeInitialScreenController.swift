//
//  HomeInitialScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 30.04.2021.
//

import UIKit

class HomeInitialScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = HomeInitialScreenViewModel()

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if segue.identifier == "HomeInitialToHomeEmptyScreenSegue" {
      guard let homeEmptyStateVC = segue.destination as? HomeEmptyScreenController else { return }
      homeEmptyStateVC.delegate = self
    }
  }

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
    viewModel.delegate = self
  }
}

// MARK: - View model delegate methods
extension HomeInitialScreenController: HomeInitialScreenViewModelDelegate {
  func showHomeEmptyStateScreen() {
    performSegue(withIdentifier: "HomeInitialToHomeEmptyScreenSegue", sender: nil)
  }

  func showHomeScreen() {
    performSegue(withIdentifier: "HomeInitialToHomeScreenSegue", sender: nil)
  }
}

// MARK: - Home empty state screen delegate methods
extension HomeInitialScreenController: HomeEmptyScreenControllerDelegate {
  func didFinishFirstQRCodeScan(_ controller: HomeEmptyScreenController) {
    controller.dismiss(animated: false) { [weak self] in
      self?.performSegue(withIdentifier: "HomeInitialToHomeScreenSegue", sender: nil)
    }
  }
}
