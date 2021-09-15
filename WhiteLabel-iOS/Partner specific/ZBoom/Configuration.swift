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
  static let activeHost = Host.staging
  static let phoneNumberPrefix = ""
}
