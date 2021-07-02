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
    // TODO: need localization for texts below
    switch receiptModel.state {
    case .approved:
      // TODO: need to add partner specific text for description below
      return ReceiptStatusInfo(title: "Поздравляем, чек принят!",
                               description: "Когда общая сумма чеков будет равна 3 300, вы получите купон на покупку электрического чайника Lion Sabatier International за 1 рубль",
                               iconName: "iconReceiptStatusApproved",
                               colorName: "StatusGreen")
    case .processing:
      return ReceiptStatusInfo(title: "Ваш чек находится на проверке",
                               description: "Обычно это занимает несколько минут, но очень редко на это уходит много времени.\nКогда ваш чек пройдет проверку, вы сможете отсканировать новый.",
                               iconName: "iconReceiptStatusProcessing",
                               colorName: "StatusOrange")
    case .rejected:
      return ReceiptStatusInfo(title: "Ваш чек не прошел проверку!",
                               description: receiptModel.rejectReason,
                               iconName: "iconReceiptStatusRejected",
                               colorName: "StatusRed")
    default:
      return statusInfo(forReceipt: receiptModel)
    }
  }
}
