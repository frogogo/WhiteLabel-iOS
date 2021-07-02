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
  let statusColorName = Box(value: "")

  // MARK: - Internal/public custom methods
  func setReceiptModel(_ receiptModel: ReceiptModel) {
    numberText.value = "№ \(receiptModel.number)"
    sumText.value = CurrencyHelper.readableSumInRubles(withAmount: receiptModel.sum)
    statusIconName.value = stateIconName(forReceiptState: receiptModel.state)
    statusColorName.value = stateColorName(forReceiptState: receiptModel.state)
    
    if let receiptDate = receiptModel.timestamp {
      dateText.value = receiptDate.readableDateWithTime()
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

  private func stateColorName(forReceiptState receiptState: ReceiptState) -> String {
    switch receiptState {
    case .approved:
      return "StatusGreen"
    case .processing:
      return "StatusOrange"
    case .rejected:
      return "StatusRed"
    default:
      return "StatusGreen"
    }
  }
}
