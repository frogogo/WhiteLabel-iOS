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
  
  // MARK: - Internal/public custom methods
  func checkHomeData(onSuccess: @escaping (Bool) -> Void,
                     onFailure: @escaping (String) -> Void) {

    APIConnector.shared.requestGET("home") { (isOK, response, errors) in
      if isOK {

        var receipts: [String] = []
        var coupons: [String] = []

        // TODO: тут надо распарсить все данные и записать их в переменные

        let isReceiptsAndCouponsNotEmpty = receipts.count > 0 || coupons.count > 0
        onSuccess(isReceiptsAndCouponsNotEmpty)

      } else {
        print("Occured errors = \(errors)")
        let errorText = errors[0]["error_text"].stringValue
        onFailure(errorText)
      }
    }
  }
}
