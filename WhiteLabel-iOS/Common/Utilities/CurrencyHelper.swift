//
//  CurrencyHelper.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 14.05.2021.
//

import Foundation

class CurrencyHelper {
  static func readableSumInRubles(withAmount sum: Double) -> String {
    let currencySymbol = Configuration.currencySymbol
    let pricePrecision = Configuration.pricePrecision
    let formattedPrice = String(format: "%.\(pricePrecision)f", sum)
    return "\(formattedPrice) \(currencySymbol)"
  }
}
