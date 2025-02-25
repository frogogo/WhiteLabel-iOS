//
//  PhoneEnterScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 20.04.2021.
//

import Foundation

protocol PhoneEnterScreenViewModelDelegate: AnyObject {
  func didSendEnteredPhone()
}

class PhoneEnterScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: PhoneEnterScreenViewModelDelegate?
  var enteredPhoneNumber = ""
  var retryDelayInSeconds = 0

  let titleText = LocalizedString(forKey: "auth.phone_enter_screen.title")
  let hintText = LocalizedString(forKey: "auth.phone_enter_screen.hint")
  let continueButtonTitleText = LocalizedString(forKey: "auth.phone_enter_screen.continue_button.title")
  let retryButtonTitleText = LocalizedString(forKey: "auth.phone_enter_screen.retry_button.title")
  let phoneCode = Box(value: "")
  let showActivity = Box(value: false)
  let errorToShow: Box<String?> = Box(value: nil)

  private let phoneCodeString = Configuration.phoneNumberPrefix

  // MARK: - Lifecycle methods
  override init() {
    super.init()
    phoneCode.value = phoneCodeString
  }

  // MARK: - Internal/public custom methods
  func sendEnteredPhone(_ enteredPhoneString: String) {
    enteredPhoneNumber = phoneCodeString + enteredPhoneString
    sendPhoneNumberForCheck(enteredPhoneNumber)
  }

  func retryEnteredPhoneSending() {
    if enteredPhoneNumber != "" {
      sendPhoneNumberForCheck(enteredPhoneNumber)
    } else {
      errorToShow.value = LocalizedString(forKey: "auth.phone_enter_screen.error.incorrect_phone_number")
    }
  }

  // MARK: - Private custom methods
  private func sendPhoneNumberForCheck(_ phoneNumberString: String) {
    errorToShow.value = nil
    showActivity.value = true
    
    AccountManager.shared.requestAuthCode(forPhoneNumber: phoneNumberString) { [weak self] (retryDelayInSeconds) in
      self?.showActivity.value = false
      self?.retryDelayInSeconds = retryDelayInSeconds
      self?.delegate?.didSendEnteredPhone()
    } onFailure: { [weak self] (error) in
      self?.showActivity.value = false
      self?.errorToShow.value = LocalizedString(forKey: "error.unknown")
    }
  }
}
