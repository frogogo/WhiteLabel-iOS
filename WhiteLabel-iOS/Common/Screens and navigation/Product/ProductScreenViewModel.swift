//
//  ProductScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 06.08.2021.
//

import Foundation

protocol ProductScreenViewModelDelegate: AnyObject {
  func occuredError(withText errorText: String)
}

class ProductScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: ProductScreenViewModelDelegate?
  var productIDForDisplay: String?

  let pictureURL = Box(value: "")
  let discountedPrice = Box(value: "")
  let price = Box(value: "")
  let productName = Box(value: "")
  let specs = Box(value: "")
  let description = Box(value: "")

  private var productModel: ProductModel?

  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    guard let productID = productIDForDisplay else { return }
    ProductManager.shared.loadProduct(withID: productID) { [weak self] loadedProduct in
      self?.productModel = loadedProduct
      self?.updateInfoForDisplay()
    } onFailure: { [weak self] error in
      self?.delegate?.occuredError(withText: error)
    }
  }

  private func updateInfoForDisplay() {
    guard let productToDisplay = productModel else { return }
    pictureURL.value = productToDisplay.photoURL
    discountedPrice.value = CurrencyHelper.readableSum(withAmount: productToDisplay.discountedPrice)
    price.value = CurrencyHelper.readableSum(withAmount: productToDisplay.price)
    productName.value = productToDisplay.name
    specs.value = productToDisplay.specs
    description.value = productToDisplay.description
  }
}
