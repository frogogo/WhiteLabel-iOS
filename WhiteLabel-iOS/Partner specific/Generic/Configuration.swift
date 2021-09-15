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
  static let activeHost = Host.production
  static let phoneNumberPrefix = "+7"
}
