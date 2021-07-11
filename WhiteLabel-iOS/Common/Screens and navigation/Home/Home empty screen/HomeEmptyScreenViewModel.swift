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

  var productCellCount: Int {
    return productSectionViewModel.productCellCount
  }

  private (set) var promotionViewModel = PromotionItemViewModel(withModel: nil)

  private let productSectionViewModel = ProductListScreenViewModel()
  private var promotionModel = PromotionModel()

  // MARK: - Lifecycle methods
  override init() {
    super.init()
    productSectionViewModel.delegate = self
  }

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

    productSectionViewModel.refreshData()
  }

  // MARK: - Internal/public custom methods
  func stepInstructionText(forIndex stepIndex: Int) -> String {
    guard stepIndex <= promotionModel.steps.endIndex else { return "" }
    return promotionModel.steps[stepIndex]
  }

  func productViewModel(forIndex index: Int) -> ProductViewModel {
    return productSectionViewModel.productViewModel(forIndex: index)
  }
}

// MARK: - View model delegate methods
extension HomeEmptyScreenViewModel: ProductListScreenViewModelDelegate {
  func viewModelUpdated() {
    delegate?.viewModelUpdated()
  }
}
