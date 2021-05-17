//
//  ReceiptScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.05.2021.
//

import Foundation

class ReceiptScreenViewModel: BaseViewModel {
  // MARK: - Properties
  let numberText = Box(value: "")
  let sumText = Box(value: "")
  let dateText = Box(value: "")
  let statusIconName = Box(value: "")

  // MARK: - Internal/public custom methods
  func setReceiptModel(_ receiptModel: ReceiptModel) {
    numberText.value = "№ \(receiptModel.number)"
    sumText.value = CurrencyHelper.readableSumInRubles(withAmount: receiptModel.sum)
    statusIconName.value = stateIconName(forReceiptState: receiptModel.state)

    if let scanDate = receiptModel.timestamp {
      dateText.value = scanDate.readableDateWithTime()
    }
  }

  // MARK: - Private custom methods
  private func stateIconName(forReceiptState receiptState: ReceiptState) -> String {
    switch receiptState {
    case .approved:
      return "iconReceiptStatusApproved"
    case .processing:
      return "iconReceiptStatusProcessing"
    case .rejected:
      return "iconReceiptStatusRejected"
    default:
      return "iconReceiptStatusProcessing"
    }
  }
}
