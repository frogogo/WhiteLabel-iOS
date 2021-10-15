//
//  HomeManager.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 12.05.2021.
//

import Foundation

class HomeManager: BaseDataManager {
  // MARK: - Properties
  static let shared = HomeManager()

  let promotion = PromotionModel()
  let commonCouponInfo = CommonCouponInfoModel()
  let couponProgress = CouponProgressModel()
  var receipts: [ReceiptModel] = []
  var coupons: [CouponModel] = []

  var hasNewUnseenCoupon: Bool {
    return UserDefaults.standard.bool(forKey: hasNewUnseenCouponKey)
  }

  private let couponCountBeforeLastRefreshKey = "couponCounterKey"
  private let hasNewUnseenCouponKey = "hasNewUnseenCouponKey"
  
  // MARK: - Internal/public custom methods
  func checkHomeData(onSuccess: @escaping (Bool) -> Void,
                     onFailure: @escaping (String) -> Void) {

    updateHomeData { [weak self] in
      guard let self = self else { return }
      let isReceiptsAndCouponsNotEmpty = self.receipts.count > 0 || self.coupons.count > 0
      onSuccess(isReceiptsAndCouponsNotEmpty)
    } onFailure: { (error) in
      onFailure(error)
    }
  }

  func refreshHomeData(onSuccess: @escaping () -> Void,
                       onFailure: @escaping (String) -> Void) {
    updateHomeData {
      onSuccess()
    } onFailure: { error in
      onFailure(error)
    }
  }

  func markAllCouponsAsSeen() {
    UserDefaults.standard.setValue(false, forKey: hasNewUnseenCouponKey)
    UserDefaults.standard.synchronize()
  }

  // MARK: - Private custom methods
  private func updateHomeData(onSuccess: @escaping () -> Void,
                              onFailure: @escaping (String) -> Void) {
    apiConnector.requestGET("home") { [weak self] (isOK, response, errors) in
      guard let self = self else { return }
      if isOK {
        self.promotion.update(with: response["promotion"])
        self.commonCouponInfo.update(with: response["coupon"])
        self.couponProgress.update(with: response["progress"])
        self.receipts = ReceiptModel.array(withJSONDataArray: response["receipts"].arrayValue)
        self.coupons = CouponModel.array(withJSONDataArray: response["coupons"].arrayValue)
        self.updateCouponCounter()
        onSuccess()

      } else {
        print("\(type(of: self)): home data load failed. Occured errors = \(errors)")
        let errorText = errors[0].description
        onFailure(errorText)
      }
    }
  }

  private func updateCouponCounter() {
    let savedCouponCount = UserDefaults.standard.integer(forKey: couponCountBeforeLastRefreshKey)
    let updatedCouponCount = coupons.count

    if savedCouponCount < updatedCouponCount {
      UserDefaults.standard.setValue(true, forKey: hasNewUnseenCouponKey)
    }
    UserDefaults.standard.setValue(updatedCouponCount, forKey: couponCountBeforeLastRefreshKey)
    UserDefaults.standard.synchronize()
  }
}
