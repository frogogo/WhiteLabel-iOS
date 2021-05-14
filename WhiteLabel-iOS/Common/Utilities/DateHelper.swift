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
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter.date(from: isoString)
  }

  // MARK: - Internal/public custom methods
  func readableDateWithTime(forLocale locale: Locale = Locale(identifier: "ru_RU")) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy - H:mm"
    formatter.locale = locale

    return formatter.string(from: self)
  }
}
