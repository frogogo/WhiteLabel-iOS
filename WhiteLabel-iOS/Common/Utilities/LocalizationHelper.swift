//
//  LocalizationHelper.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 04.09.2021.
//

import Foundation

func LocalizedString(forKey key: String) -> String {
  return NSLocalizedString(key, comment: "")
}

func LocalizedString(forKey key: String, _ arguments: CVarArg...) -> String {
  return String(format: LocalizedString(forKey: key), arguments: arguments)
}
