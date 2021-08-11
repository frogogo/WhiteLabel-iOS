//
//  ProductManager.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 08.07.2021.
//

import Foundation

class ProductManager: BaseDataManager {
  // MARK: - Properties
  static let shared = ProductManager()

  var products: [ProductModel] = []

  private var isProductsLoaded = false
  
  // MARK: - Internal/public custom methods
  func loadProducts(onSuccess: @escaping ([ProductModel]) -> Void,
                    onFailure: @escaping (String) -> Void) {
    if isProductsLoaded {
      onSuccess(products)
      return
    }

    apiConnector.requestGET("items") { [weak self] isOK, response, errors in
      guard let self = self else { return }

      if isOK {
        self.isProductsLoaded = true
        self.products = ProductModel.array(withJSONDataArray: response.arrayValue)
        onSuccess(self.products)
      } else {
        print("\(type(of: self)): product list load failed. Occured errors = \(errors)")
        let errorText = errors[0].description
        onFailure(errorText)
      }
    }
  }

  func loadProduct(withID productID: String,
                   onSuccess: @escaping (ProductModel) -> Void,
                   onFailure: @escaping (String) -> Void) {

    apiConnector.requestGET("items/\(productID)") { [weak self] isOK, response, errors in
      if isOK {
        let parsedProduct = ProductModel()
        parsedProduct.update(with: response)
        onSuccess(parsedProduct)
      } else {
        print("\(type(of: self)): product load failed. Occured errors = \(errors)")
        let errorText = errors[0].description
        onFailure(errorText)
      }
    }
  }
}
