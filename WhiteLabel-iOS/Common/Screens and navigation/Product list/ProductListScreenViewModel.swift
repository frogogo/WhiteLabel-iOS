//
//  ProductListScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 08.07.2021.
//

import Foundation

protocol ProductListScreenViewModelDelegate: AnyObject {
  func viewModelUpdated()
}

class ProductListScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: ProductListScreenViewModelDelegate?
  var productCellCount: Int {
    return productViewModels.count
  }

  private (set) var promotionViewModel = PromotionItemViewModel(withModel: nil)

  private var productViewModels: [ProductCellViewModel] = []
  private var productList: [ProductModel] = []

  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    promotionViewModel.update(with: HomeManager.shared.promotion)
    delegate?.viewModelUpdated()

    ProductManager.shared.loadProducts { [weak self] (loadedProducts) in
      guard let self = self else { return }
      self.productList = loadedProducts
      self.createProductViewModels(withProductModels: loadedProducts)
      self.delegate?.viewModelUpdated()
      
    } onFailure: { error in
      print("\(type(of: self)): product list load failed: \(error)")
    }
  }

  // MARK: - Internal/public custom methods
  func productID(forIndex index: Int) -> String? {
    guard index < productList.count else { return nil }
    return productList[index].identifier
  }

  func productViewModel(forIndex index: Int) -> ProductCellViewModel {
    return productViewModels[index]
  }

  // MARK: - Private custom methods
  private func createProductViewModels(withProductModels productModels: [ProductModel]) {
    productViewModels.removeAll()

    let productCellCount = Int(ceilf(Float(productModels.count) / 2 ))

    for index in 0..<productCellCount {
      let leftSlotIndex = index * 2
      let rightSlotIndex = index * 2 + 1

      var productModelsToSet = Array(arrayLiteral: productModels[leftSlotIndex])
      if rightSlotIndex < productModels.count {
        let rightSlotModel = productModels[rightSlotIndex]
        productModelsToSet.append(rightSlotModel)
      }

      let productViewModel = ProductCellViewModel()
      productViewModel.setProducts(productModelsToSet)
      productViewModels.append(productViewModel)
    }
  }
}
