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
    return promotion.steps.count
  }
  var promotionName: String {
    return promotion.name
  }
  var promotionPictureURL: String {
    return promotion.photo.largePhotoURL
  }

  private var promotion = PromotionModel()

  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    HomeManager.shared.refreshHomeData { [weak self] in
      guard let self = self else { return }
      self.promotion = HomeManager.shared.promotion
      self.delegate?.viewModelUpdated()
    }
  }

  // MARK: - Internal/public custom methods
  func stepInstructionText(forIndex stepIndex: Int) -> String {
    guard stepIndex <= promotion.steps.endIndex else { return "" }
    return promotion.steps[stepIndex]
  }
}
