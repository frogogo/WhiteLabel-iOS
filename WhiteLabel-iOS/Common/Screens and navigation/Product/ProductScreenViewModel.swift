//
//  ProductScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 06.08.2021.
//

import Foundation

class ProductScreenViewModel: BaseViewModel {
  // MARK: - Properties
  let productName = Box(value: "")

  var productModel: ProductModel? {
    didSet {
      refreshData()
    }
  }

  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    guard let productID = productModel?.name else { return }
    // TODO: тут надо загрузить данные о товаре
    // TODO: remove string below
    productName.value = productID
  }
}
