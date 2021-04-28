//
//  AuthCodeEnterScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 23.04.2021.
//

import Foundation

protocol AuthCodeEnterScreenViewModelDelegate: AnyObject {
  func didRegisterUser()
  func didLogInUser()
}

class AuthCodeEnterScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: AuthCodeEnterScreenViewModelDelegate?

  var enteredPhoneNumber: String {
    get {
      return phoneNumber.value
    }
    set (newValue) {
      phoneNumber.value = newValue
    }
  }
  var newAuthCodeRetryDelayInSeconds: Int = 0 {
    didSet {
      if newAuthCodeRetryDelayInSeconds >= 0 {
        startCountdownTimer()
      }
    }
  }

  let phoneNumber = Box(value: "")
  let retryTimerText = Box(value: "")
  let errorToShow: Box<String?> = Box(value: nil)
  let showActivity = Box(value: false)
  let isRequestNewAuthCodeAllowed = Box(value: false)

  private var sendAuthCodeRetryTimer: Timer!

  // MARK: - Internal/public custom methods
  func sendAuthCode(_ authCode: String) {
    errorToShow.value = nil
    showActivity.value = true

    AccountManager.shared.auth(withPhoneNumber: enteredPhoneNumber, andCode: authCode) {
      [weak self] (isNewUser) in
      self?.showActivity.value = false
      if isNewUser {
        self?.delegate?.didRegisterUser()
      } else {
        self?.delegate?.didLogInUser()
      }
    } onFailure: { [weak self] (errorText) in
      self?.showActivity.value = false
      self?.errorToShow.value = errorText
    }
  }
  
  func requestNewAuthCode() {
    errorToShow.value = nil
    showActivity.value = true

    AccountManager.shared.requestAuthCode(forPhoneNumber: enteredPhoneNumber) { [weak self] (retryDelayInSeconds) in
      self?.showActivity.value = false
      self?.newAuthCodeRetryDelayInSeconds = retryDelayInSeconds
    } onFailure: { [weak self] (error) in
      self?.showActivity.value = false
      self?.errorToShow.value = "Что-то пошло не так!"
    }
  }

  // MARK: - Private custom methods
  private func startCountdownTimer() {
    if sendAuthCodeRetryTimer != nil {
      sendAuthCodeRetryTimer.invalidate()
      sendAuthCodeRetryTimer = nil
    }

    updateRetryTimerText()
    isRequestNewAuthCodeAllowed.value = false

    sendAuthCodeRetryTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
      guard let self = self else { return }
      self.newAuthCodeRetryDelayInSeconds -= 1
      self.updateRetryTimerText()
      if self.newAuthCodeRetryDelayInSeconds <= 0 {
        timer.invalidate()
        self.sendAuthCodeRetryTimer = nil
        self.isRequestNewAuthCodeAllowed.value = true
      }
    }
  }

  private func updateRetryTimerText() {
    // TODO: add plural for seconds
    retryTimerText.value = "Повторно запросить код можно через: \(newAuthCodeRetryDelayInSeconds)"
  }
}
