//
//  QRCodeScannerViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.05.2021.
//

import Foundation

protocol QRCodeScannerViewModelDelegate: AnyObject {
  func showScanSuccess()
}

class QRCodeScannerViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: QRCodeScannerViewModelDelegate?

  var receipt: ReceiptModel?

  // MARK: - Internal/public custom methods
  func handleParsedQRCodeString(_ qrCodeString: String) {
    ReceiptManager.shared.sendReceipt(withQRString: qrCodeString) { [weak self] (createdReceipt) in
      self?.receipt = createdReceipt
      self?.delegate?.showScanSuccess()
    } onFailure: { error in
      print("Ошибка сканирования: \(error)")
    }
  }
}
