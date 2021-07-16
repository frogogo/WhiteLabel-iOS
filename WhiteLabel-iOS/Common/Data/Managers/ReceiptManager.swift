//
//  ReceiptManager.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.05.2021.
//

import Foundation

class ReceiptManager: BaseDataManager {
  // MARK: - Properties
  static let shared = ReceiptManager()

  // MARK: - Internal/public custom methods
  func sendReceipt(withQRString parsedQRString: String,
                   onSuccess: @escaping (ReceiptModel) -> Void,
                   onFailure: @escaping (String) -> Void) {

    let params = ["qr_string": parsedQRString]
    apiConnector.requestPOST("receipts", params: params) { isOK, response, errors in
      if isOK {
        let parsedReceipt = ReceiptModel()
        parsedReceipt.update(with: response)
        onSuccess(parsedReceipt)
      } else {
        print("\(type(of: self)): QR code sending failed. Occured errors = \(errors)")
        let errorText = errors[0].description
        onFailure(errorText)
      }
    }
  }
}
