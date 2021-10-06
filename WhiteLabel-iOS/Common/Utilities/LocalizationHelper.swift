//
//  LocalizationHelper.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 04.09.2021.
//

import Foundation

func LocalizedString(forKey key: String,
                     targetSpecific useTargetSpecificStringFile: Bool = false) -> String {
  if useTargetSpecificStringFile {
    return NSLocalizedString(key, tableName: Configuration.targetSpecificStringsFileName, comment: "")
  } else {
    return NSLocalizedString(key, comment: "")
  }
}

func LocalizedString(forKey key: String,
                     targetSpecific useTargetSpecificStringFile: Bool = false,
                     _ arguments: CVarArg...) -> String {
  return String(format: LocalizedString(forKey: key, targetSpecific: useTargetSpecificStringFile), arguments: arguments)
}
