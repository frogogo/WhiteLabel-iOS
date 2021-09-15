//
//  QRCodeScannerViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.05.2021.
//

import Foundation

protocol QRCodeScannerViewModelDelegate: AnyObject {
  func showScanSuccess()
  func showScanError(_ errorText: String)
}

class QRCodeScannerViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: QRCodeScannerViewModelDelegate?

  let hintText = LocalizedString(forKey: "qr_code_scanner_screen.hint")
  let helpButtonTitle = LocalizedString(forKey: "qr_code_scanner_screen.hint")
  var receipt: ReceiptModel?

  // MARK: - Internal/public custom methods
  func handleParsedQRCodeString(_ qrCodeString: String) {
    ReceiptManager.shared.sendReceipt(withQRString: qrCodeString) { [weak self] (createdReceipt) in
      self?.receipt = createdReceipt
      self?.delegate?.showScanSuccess()
    } onFailure: { [weak self] (errorText) in
      self?.delegate?.showScanError(errorText)
    }
  }
}
