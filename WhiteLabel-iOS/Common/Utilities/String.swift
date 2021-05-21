//
//  String.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 21.05.2021.
//

import Foundation

extension String {
  var isValidEmail: Bool {
    let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}",
                                         options: .caseInsensitive)
    return regex?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
  }
}
