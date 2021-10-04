//
//  Configuration.swift
//  Generic
//
//  Created by megaorega on 07.09.2021.
//

import Foundation

private struct Host {
  static let staging    = "https://sboom-staging.herokuapp.com"
  static let production = "https://sboom.herokuapp.com"
}

struct Configuration {
  // MARK: Localization settings
  static let targetSpecificStringsFileName = "Localizable-Generic"

  // MARK: API connection settings
  static let activeHost = Host.production

  // MARK: Auth settings
  static let phoneNumberPrefix = "+7"

  // MARK: Price display settings
  static let currencySymbol = "₽"
  // price precision is number of digits after floating point
  static let pricePrecision = 0
}
