//
//  QRCodeScannerViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.05.2021.
//

import Foundation

class QRCodeScannerViewModel: BaseViewModel {
  // MARK: - Internal/public custom methods
  func handleParsedQRCodeString(_ qrCodeString: String) {
    print("Надо отправить на сервер строку из QR кода:\n \(qrCodeString)")
  }
}
