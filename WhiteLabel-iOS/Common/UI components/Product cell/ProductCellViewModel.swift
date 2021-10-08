//
//  ProductCellViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 09.07.2021.
//

import Foundation

class ProductCellViewModel: BaseViewModel {
  // MARK: - Properties
  var needToDisplayRightSlot: Bool {
    return products.count > 1
  }
  
  private var products: [ProductModel] = []

  // MARK: - Internal/public custom methods
  func setProducts(_ productModels: [ProductModel]) {
    products = productModels
  }

  func productPictureURL(forSlot slotIndex: Int) -> String {
    return products[slotIndex].photoURL
  }

  func productName(forSlot slotIndex: Int) -> String {
    return products[slotIndex].name
  }

  func productSpecs(forSlot slotIndex: Int) -> String {
    return products[slotIndex].specs
  }

  func productPrice(forSlot slotIndex: Int) -> String {
    return CurrencyHelper.readableSum(withAmount: products[slotIndex].price)
  }

  func productDiscountedPrice(forSlot slotIndex: Int) -> String {
    return CurrencyHelper.readableSum(withAmount: products[slotIndex].discountedPrice)
  }
}
