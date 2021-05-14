//
//  DateHelper.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 14.05.2021.
//

import Foundation

extension Date {
  // MARK: - Static methods
  static func date(fromISOString isoString: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions.insert(.withFractionalSeconds)
    return formatter.date(from: isoString)
  }

  // MARK: - Internal/public custom methods
  func readableDateWithTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy - H:mm"

    return formatter.string(from: self)
  }
}
