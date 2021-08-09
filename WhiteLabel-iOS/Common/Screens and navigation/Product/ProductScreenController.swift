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

  @IBOutlet private var picture: UIImageView!
  @IBOutlet private var discountedPriceLabel: UILabel!
  @IBOutlet private var priceLabel: UILabel!
  @IBOutlet private var nameLabel: UILabel!
  @IBOutlet private var specsLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!

  // MARK: - Lifecycle methods

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
    viewModel.delegate = self
  }

  override func addBindings() {
    super.addBindings()

    viewModel.pictureURL.bind { [weak self] pictureURLString in
      self?.picture.kf.setImage(with: URL(string: pictureURLString))
    }
    viewModel.discountedPrice.bind { [weak self] discountedPriceString in
      self?.discountedPriceLabel.text = discountedPriceString
    }
    viewModel.price.bind { [weak self] priceString in
      self?.priceLabel.text = priceString
    }
    viewModel.productName.bind { [weak self] productNameString in
      self?.nameLabel.text = productNameString
    }
    viewModel.specs.bind { [weak self] specsString in
      self?.specsLabel.text = specsString
    }
    viewModel.description.bind { [weak self] descriptionString in
      self?.descriptionLabel.text = descriptionString
    }
  }

  // MARK: - Handlers
  @IBAction func closeButtonTap() {
    dismiss(animated: true, completion: nil)
  }
}

extension ProductScreenController: ProductScreenViewModelDelegate {
  func occuredError(withText errorText: String) {
    showStandardErrorAlert(withMessage: errorText)
  }
}
