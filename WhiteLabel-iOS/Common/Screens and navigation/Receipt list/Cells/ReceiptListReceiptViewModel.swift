//
//  ReceiptListReceiptViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 14.05.2021.
//

import Foundation

class ReceiptListReceiptViewModel: BaseViewModel {
  // MARK: - Properties
  let numberString = Box(value: "")
  let sumText = Box(value: "")
  let timeText = Box(value: "")
  let statusTitleText = Box(value: "")
  let statusIconName = Box(value: "")
  let statusColorName = Box(value: "")

  // MARK: - Lifecycle methods
  init(withModel receiptModel: ReceiptModel) {
    super.init()
    update(with: receiptModel)
  }

  // MARK: - Internal/public custom methods
  func update(with receiptModel: ReceiptModel) {
    numberString.value = "№ \(receiptModel.number)"
    sumText.value = CurrencyHelper.readableSum(withAmount: receiptModel.sum)
    statusIconName.value = stateIconName(forReceiptState: receiptModel.state)
    statusTitleText.value = stateTitleText(forReceiptState: receiptModel.state)
    statusColorName.value = stateColorName(forReceiptState: receiptModel.state)
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

  private func stateTitleText(forReceiptState receiptState: ReceiptState) -> String {
    // TODO: add localization below!
    switch receiptState {
    case .approved:
      return "Принят"
    case .processing:
      return "Проверяется"
    case .rejected:
      return "Отклонен"
    default:
      return "Неизвестно"
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
      return "StatusOrange"
    }
  }
}
