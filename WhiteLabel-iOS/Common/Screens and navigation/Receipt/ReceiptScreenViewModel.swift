//
//  ReceiptScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.05.2021.
//

import Foundation

private struct ReceiptStatusInfo {
  var title: String
  var description: String
  var iconName: String
  var colorName: String
}

class ReceiptScreenViewModel: BaseViewModel {
  // MARK: - Properties
  let numberText = Box(value: "")
  let sumText = Box(value: "")
  let dateText = Box(value: "")
  let statusIconName = Box(value: "")
  let statusColorName = Box(value: "")
  let statusTitle = Box(value: "")
  let statusDescription = Box(value: "")

  // MARK: - Internal/public custom methods
  func setReceiptModel(_ receiptModel: ReceiptModel) {
    numberText.value = "№ \(receiptModel.number)"
    sumText.value = CurrencyHelper.readableSumInRubles(withAmount: receiptModel.sum)

    if let receiptDate = receiptModel.timestamp {
      dateText.value = receiptDate.readableDateWithTime()
    }
    
    let statusInfo = statusInfo(forReceipt: receiptModel)
    statusIconName.value = statusInfo.iconName
    statusColorName.value = statusInfo.colorName
    statusTitle.value = statusInfo.title
    statusDescription.value = statusInfo.description
  }

  // MARK: - Private custom methods
  private func statusInfo(forReceipt receiptModel: ReceiptModel) -> ReceiptStatusInfo {
    switch receiptModel.state {
    case .approved:
      return ReceiptStatusInfo(title: LocalizedString(forKey: "receipt_screen.status.approved.title"),
                               description: LocalizedString(forKey: "receipt_screen.status.approved.description",
                                                            targetSpecific: true),
                               iconName: "iconReceiptStatusApproved",
                               colorName: "StatusGreen")
    case .processing:
      return ReceiptStatusInfo(title: LocalizedString(forKey: "receipt_screen.status.processing.title"),
                               description: LocalizedString(forKey: "receipt_screen.status.processing.description"),
                               iconName: "iconReceiptStatusProcessing",
                               colorName: "StatusOrange")
    case .rejected:
      return ReceiptStatusInfo(title: LocalizedString(forKey: "receipt_screen.status.rejected.title"),
                               description: receiptModel.rejectReason,
                               iconName: "iconReceiptStatusRejected",
                               colorName: "StatusRed")
    default:
      return statusInfo(forReceipt: receiptModel)
    }
  }
}
