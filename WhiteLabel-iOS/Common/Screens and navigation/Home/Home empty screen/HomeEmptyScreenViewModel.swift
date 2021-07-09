//
//  HomeEmptyScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 07.05.2021.
//

import Foundation

protocol HomeEmptyScreenViewModelDelegate: AnyObject {
  func viewModelUpdated()
}

class HomeEmptyScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: HomeEmptyScreenViewModelDelegate?

  var promotionStepsCount: Int {
    return promotionModel.steps.count
  }

  private (set) var promotionViewModel = PromotionItemViewModel(withModel: nil)

  private var promotionModel = PromotionModel()
  private var productList: [ProductModel] = []

  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    HomeManager.shared.refreshHomeData { [weak self] in
      guard let self = self else { return }
      self.promotionModel = HomeManager.shared.promotion
      self.promotionViewModel.update(with: self.promotionModel)
      self.delegate?.viewModelUpdated()
    } onFailure: { error in
      print("\(type(of: self)): data refresh failed: \(error)")
    }

    ProductManager.shared.loadProducts {[weak self] (products) in
      guard let self = self else { return }
      self.productList = products
      self.delegate?.viewModelUpdated()
    } onFailure: { error in
      print("\(type(of: self)): products load failed: \(error)")
    }
  }

  // MARK: - Internal/public custom methods
  func stepInstructionText(forIndex stepIndex: Int) -> String {
    guard stepIndex <= promotionModel.steps.endIndex else { return "" }
    return promotionModel.steps[stepIndex]
  }

  // TODO: need to add method for product cell view model creation here
}
