//
//  HomeScreenCouponViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 14.05.2021.
//

import Foundation

class HomeScreenCouponViewModel: BaseViewModel {
  // MARK: - Properties
  let titleText = Box(value: "")
  let pictureURL = Box(value: "")
  let numberString = Box(value: "")

  private (set) var couponModel = CouponModel()
  
  // MARK: - Lifecycle methods
  init(withModel couponModel: CouponModel) {
    super.init()
    update(with: couponModel)
  }

  // MARK: - Internal/public custom methods
  func update(with couponModel: CouponModel) {
    self.couponModel = couponModel
    // TODO: need localization
    numberString.value = "Купон № \(couponModel.identifier)"
  }
}
