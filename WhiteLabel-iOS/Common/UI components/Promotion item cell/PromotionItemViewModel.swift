//
//  PromotionItemViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 09.07.2021.
//

import Foundation

class PromotionItemViewModel: BaseViewModel {
  // MARK: - Properties
  let couponTagString = Box(value: LocalizedString(forKey: "common.promotion_item_cell.coupon_hint"))
  let pictureURL = Box(value: "")
  let nameString = Box(value: "")
  let discountedPriceString = Box(value: "")
  let priceString = Box(value: "")
  
  private (set) var promotionModel = PromotionModel()

  // MARK: - Lifecycle methods
  init(withModel promotionModel: PromotionModel?) {
    super.init()

    guard promotionModel != nil else { return }
    update(with: promotionModel!)
  }

  // MARK: - Internal/public custom methods
  func update(with promotionModel: PromotionModel) {
    self.promotionModel = promotionModel
    
    pictureURL.value = promotionModel.photo.largePhotoURL
    nameString.value = promotionModel.name
    discountedPriceString.value = CurrencyHelper.readableSum(withAmount: promotionModel.discountedPrice)
    priceString.value = CurrencyHelper.readableSum(withAmount: promotionModel.price)
  }
}
