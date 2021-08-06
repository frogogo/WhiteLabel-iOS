//
//  ProductScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 06.08.2021.
//

import UIKit

class ProductScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = ProductScreenViewModel()

  // MARK: - Lifecycle methods

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
  }

  // MARK: - Handlers
  @IBAction func closeButtonTap() {
    dismiss(animated: true, completion: nil)
  }
}
