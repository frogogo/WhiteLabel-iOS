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

  let instructionTitleText = LocalizedString(forKey: "coupon.coupon_detail_screen.instruction_title")
  let showCodeButtonTitle = LocalizedString(forKey: "coupon.coupon_detail_screen.show_code_button.title")
  var instructionStepsCount: Int {
    return commonCouponInfoModel.steps.count
  }
  var displayName: String {
    return commonCouponInfoModel.name
  }
  var number: String {
    return LocalizedString(forKey: "coupon.coupon_detail_screen.coupon_number") + " " + coupon.identifier
  }
  var pictureURL: String {
    return commonCouponInfoModel.photo.largePhotoURL
  }
  var barcodeString: String {
    return coupon.code
  }

  private var commonCouponInfoModel = CommonCouponInfoModel()

  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    commonCouponInfoModel = HomeManager.shared.commonCouponInfo
    delegate?.viewModelUpdated()
  }

  // MARK: - Internal/public custom methods
  func stepInstructionText(forIndex stepIndex: Int) -> String {
    guard stepIndex <= commonCouponInfoModel.steps.endIndex else { return "" }
    return commonCouponInfoModel.steps[stepIndex]
  }
}
