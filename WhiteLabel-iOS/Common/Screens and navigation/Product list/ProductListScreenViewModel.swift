//
//  ProductListScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 08.07.2021.
//

import Foundation

class ProductListScreenViewModel: BaseViewModel {
  // MARK: - Properties
  private (set) var promotionViewModel = PromotionItemViewModel(withModel: nil)
  
  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    promotionViewModel.update(with: HomeManager.shared.promotion)
  }
}
