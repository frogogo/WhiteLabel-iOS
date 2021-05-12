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

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
    viewModel.delegate = self
  }
}

extension HomeInitialScreenController: HomeInitialScreenViewModelDelegate {
  func showHomeEmptyStateScreen() {
    performSegue(withIdentifier: "HomeInitialToHomeEmptyScreenSegue", sender: nil)
  }

  func showHomeScreen() {
    performSegue(withIdentifier: "HomeInitialToHomeScreenSegue", sender: nil)
  }
}
