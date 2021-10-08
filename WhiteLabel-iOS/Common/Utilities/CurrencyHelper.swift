//
//  CurrencyHelper.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 14.05.2021.
//

import Foundation

enum PriceDisplayFormat {
  /// In this case price will be represented in this order: currency symbol, sum. Use it for dollar or euro display
  case symbolSum
  /// In this case price will be represented in this order: sum, space, currency symbol. Use it for russian rubles display
  case sumSpaceSymbol
}

class CurrencyHelper {
  static func readableSum(withAmount sum: Double) -> String {
    let currencySymbol = Configuration.currencySymbol
    let pricePrecision = Configuration.pricePrecision
    let format = Configuration.priceFormat
    let formattedSum = String(format: "%.\(pricePrecision)f", sum)

    switch format {
    case .sumSpaceSymbol:
      return "\(formattedSum) \(currencySymbol)"
    case .symbolSum:
      return "\(currencySymbol)\(formattedSum)"
    }
  }
}
