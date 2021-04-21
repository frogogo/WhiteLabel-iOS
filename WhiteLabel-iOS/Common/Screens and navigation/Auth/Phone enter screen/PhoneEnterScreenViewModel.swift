//
//  PhoneEnterScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 20.04.2021.
//

import Foundation

class PhoneEnterScreenViewModel: BaseViewModel {
  // MARK: - Properties
  let phoneCode = Box(value: "")
  let showActivity = Box(value: false)

  private let phoneCodeString = "+7"

  // MARK: - Lifecycle methods
  override init() {
    super.init()
    phoneCode.value = phoneCodeString
  }

  // MARK: - Internal/public custom methods
  func setEnteredPhone(_ enteredPhoneString: String) {
    print("Need to send phone \(phoneCodeString + enteredPhoneString)")
    showActivity.value = true
  }
}
