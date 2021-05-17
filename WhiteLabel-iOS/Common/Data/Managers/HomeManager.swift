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
  let couponProgress = CouponProgressModel()
  var receipts: [ReceiptModel] = []
  var coupons: [CouponModel] = []
  
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

  func refreshHomeData(onSuccess: @escaping () -> Void) {
    updateHomeData {
      onSuccess()
    } onFailure: { error in
      // do nothing
    }
  }

  // MARK: - Private custom methods
  private func updateHomeData(onSuccess: @escaping () -> Void,
                              onFailure: @escaping (String) -> Void) {
    APIConnector.shared.requestGET("home") { [weak self] (isOK, response, errors) in
      guard let self = self else { return }
      if isOK {
        self.promotion.update(with: response["promotion"])
        self.couponProgress.update(with: response["progress"])
        self.receipts = ReceiptModel.array(withJSONDataArray: response["receipts"].arrayValue)
        self.coupons = CouponModel.array(withJSONDataArray: response["coupons"].arrayValue)
        onSuccess()

      } else {
        print("\(type(of:self)): home data load error: \(errors)")
        let errorText = errors[0]["error_text"].stringValue
        onFailure(errorText)
      }
    }
  }
}
