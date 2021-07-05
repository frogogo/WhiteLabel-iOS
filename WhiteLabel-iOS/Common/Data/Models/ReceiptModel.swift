//
//  ReceiptModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 13.05.2021.
//

import Foundation
import SwiftyJSON

enum ReceiptState: String {
  case unknown = "unknown"
  case processing = "processing"
  case approved = "approved"
  case rejected = "rejected"
}

class ReceiptModel: BaseDataModel {
  // MARK: - Properties
  var identifier = ""
  var number = ""
  var state = ReceiptState.unknown
  var sum = 0
  var timestamp: Date?
  var rejectReason = ""

  // MARK: - Overridden methods
  override func update(with jsonData: JSON) {
    super.update(with: jsonData)

    identifier = jsonData["id"].stringValue
    number = jsonData["number"].stringValue
    sum = jsonData["sum"].intValue
    rejectReason = jsonData["reject_reason"]["reason_text"].stringValue

    let stateRawValue = jsonData["state"].stringValue
    if let updatedState = ReceiptState(rawValue: stateRawValue) {
      state = updatedState
    }

    let timeStampISOString = jsonData["timestamp"].stringValue
    timestamp = Date.date(fromISOString: timeStampISOString)
  }
}
