//
//  HomeScreenReceiptViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 14.05.2021.
//

import Foundation

class HomeScreenReceiptViewModel: BaseViewModel {
  // MARK: - Properties
  let sumText = Box(value: "")
  let timeText = Box(value: "")
  let statusIconName = Box(value: "")

  // MARK: - Lifecycle methods
  init(withModel receiptModel: ReceiptModel) {
    super.init()
    update(with: receiptModel)
  }

  // MARK: - Internal/public custom methods
  func update(with receiptModel: ReceiptModel) {
    sumText.value = CurrencyHelper.readableSumInRubles(withAmount: receiptModel.sum)
    statusIconName.value = stateIconName(forReceiptState: receiptModel.state)

    if let receiptScanDate = receiptModel.timestamp {
      timeText.value = receiptScanDate.readableDateWithTime()
    }
  }

  // MARK: - Private custom methods
  private func stateIconName(forReceiptState receiptState: ReceiptState) -> String {
    switch receiptState {
    case .approved:
      return "iconReceiptStatusApprovedSmall"
    case .processing:
      return "iconReceiptStatusProcessingSmall"
    case .rejected:
      return "iconReceiptStatusRejectedSmall"
    default:
      return "iconReceiptStatusProcessingSmall"
    }
  }
}
