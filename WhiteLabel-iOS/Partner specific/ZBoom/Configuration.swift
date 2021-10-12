//
//  Configuration.swift
//  Generic
//
//  Created by megaorega on 07.09.2021.
//

import Foundation

private struct Host {
  static let staging    = "https://zboom-eu-staging.herokuapp.com"
  static let production = "https://zboom.herokuapp.com"
}

struct Configuration {
  // MARK: Localization settings
  static let targetSpecificStringsFileName = "Localizable-ZBoom"

  // MARK: API connection settings
  static let activeHost = Host.staging

  // MARK: Auth settings
  static let phoneNumberPrefix = ""

  // MARK: Price display settings
  static let currencySymbol = "€"
  static let priceFormat = PriceDisplayFormat.symbolSum
  // price precision is number of digits after floating point
  static let pricePrecision = 2
}
