//
//  CouponDetailScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 15.05.2021.
//

import Foundation

protocol CouponDetailScreenViewModelDelegate: AnyObject {
  func viewModelUpdated()
}

class CouponDetailScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: CouponDetailScreenViewModelDelegate?

  var coupon = CouponModel()

  var instructionStepsCount: Int {
    return promotion.steps.count
  }
  var displayName: String {
    return promotion.name
  }
  var number: String {
    return promotion.name
  }
  var pictureURL: String {
    return promotion.photo.largePhotoURL
  }
  var barcodeString: String {
    return coupon.code
  }

  private var promotion = PromotionModel()

  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    promotion = HomeManager.shared.promotion
    delegate?.viewModelUpdated()
  }

  // MARK: - Internal/public custom methods
  func stepInstructionText(forIndex stepIndex: Int) -> String {
    guard stepIndex <= promotion.steps.endIndex else { return "" }
    return promotion.steps[stepIndex]
  }
}
