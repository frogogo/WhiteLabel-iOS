//
//  PhoneEnterScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 20.04.2021.
//

import Foundation

protocol PhoneEnterScreenViewModelDelegate: class {
  func didCheckEnteredPhone()
}

class PhoneEnterScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: PhoneEnterScreenViewModelDelegate?
  var enteredPhoneNumber: String? = nil

  let phoneCode = Box(value: "")
  let showActivity = Box(value: false)
  let errorToShow: Box<String?> = Box(value: nil)

  private let phoneCodeString = "+7"

  // MARK: - Lifecycle methods
  override init() {
    super.init()
    phoneCode.value = phoneCodeString
  }

  // MARK: - Internal/public custom methods
  func sendEnteredPhone(_ enteredPhoneString: String) {
    enteredPhoneNumber = enteredPhoneString
    sendPhoneNumberForCheck(enteredPhoneString)
  }

  func retryEnteredPhoneSending() {
    if enteredPhoneNumber != nil {
      sendPhoneNumberForCheck(enteredPhoneNumber!)
    } else {
      errorToShow.value = "Проверьте номер телефона. "
    }
  }

  // MARK: - Private custom methods
  private func sendPhoneNumberForCheck(_ phoneNumberString: String) {
    showActivity.value = true

    AccountManager.shared.auth(withPhoneNumber: phoneNumberString) { [weak self] in
      print("Auth request succeeded")
      self?.showActivity.value = false
      self?.delegate?.didCheckEnteredPhone()
    } onFailure: { [weak self] in
      print("Auth request failed")
      self?.showActivity.value = false
      self?.errorToShow.value = "Что-то пошло не так!"
    }
  }
}
