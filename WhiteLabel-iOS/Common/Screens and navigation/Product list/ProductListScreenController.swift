//
//  ProductListScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 08.07.2021.
//

import Foundation

class ProductListScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = ProductListScreenViewModel()

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
  }

  // MARK: - Handlers
  @IBAction func closeButtonTap() {
    dismiss(animated: true, completion: nil)
  }
}
