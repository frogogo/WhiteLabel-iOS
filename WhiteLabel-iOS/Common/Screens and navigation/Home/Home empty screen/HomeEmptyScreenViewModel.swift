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

  let promotionPictureURL = Box(value: "")
  let promotionName = Box(value: "")
  var promotionStepsCount = 0

  private var promotionSteps: [String] = []

  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    let promotion = HomeManager.shared.promotion
    promotionPictureURL.value = promotion.photo.largePhotoURL
    promotionName.value = promotion.name
    promotionSteps = promotion.steps

    delegate?.viewModelUpdated()
  }

  // MARK: - Internal/public custom methods
  func stepInstructionText(forIndex stepIndex: Int) -> String {
    guard stepIndex <= promotionSteps.endIndex else { return "" }
    return promotionSteps[stepIndex]
  }
}
