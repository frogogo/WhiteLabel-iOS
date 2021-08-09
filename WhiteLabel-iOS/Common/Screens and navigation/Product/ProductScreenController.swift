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

  @IBOutlet var nameLabel: UILabel!

  // MARK: - Lifecycle methods

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
  }

  override func addBindings() {
    super.addBindings()

    viewModel.productName.bind { [weak self] productNameString in
      self?.nameLabel.text = productNameString
    }
  }

  // MARK: - Handlers
  @IBAction func closeButtonTap() {
    dismiss(animated: true, completion: nil)
  }
}
