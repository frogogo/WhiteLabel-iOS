//
//  AuthCodeEnterScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 20.04.2021.
//

import UIKit
import InputMask

class AuthCodeEnterScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel =  AuthCodeEnterScreenViewModel()

  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var hintLabel: UILabel!
  @IBOutlet private var enteredPhoneNumberLabel: UILabel!
  @IBOutlet private var changePhoneNumberButton: UIButton!
  @IBOutlet private var authCodeField: UITextField!
  @IBOutlet private var activityIndicator: UIActivityIndicatorView!
  @IBOutlet private var errorIndicator: UIImageView!
  @IBOutlet private var errorLabel: UILabel!
  @IBOutlet private var retryTimerLabel: UILabel!
  @IBOutlet private var requestNewAuthCodeButton: UIButton!
  @IBOutlet private var retryComponentStackBottomConstraint: NSLayoutConstraint!

  private let retryComponentStackBottomGap: CGFloat = 24

  // MARK: - Lifecycle methods
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    subscribeForKeyboardNotifications()
    authCodeField.becomeFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromNotifications()
  }
  
  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
    viewModel.delegate = self
  }

  override func setupStaticContentForDisplay() {
    super.setupStaticContentForDisplay()

    titleLabel.text = viewModel.titleText
    hintLabel.text = viewModel.hintText
    changePhoneNumberButton.setTitle(viewModel.changePhoneNumberButtonTitleText, for: .normal)
    requestNewAuthCodeButton.setTitle(viewModel.requestNewCodeButtonTitleText, for: .normal)
  }

  override func addBindings() {
    super.addBindings()

    viewModel.phoneNumber.bind { [weak self] (phoneNumberString) in
      self?.enteredPhoneNumberLabel.text = phoneNumberString
    }
    viewModel.showActivity.bind { [weak self] (needToShowActivity) in
      if needToShowActivity {
        self?.activityIndicator.startAnimating()
      } else {
        self?.activityIndicator.stopAnimating()
      }
    }
    viewModel.retryTimerText.bind { [weak self] (retryTimerTextString) in
      self?.retryTimerLabel.text = retryTimerTextString
    }
    viewModel.errorToShow.bind { [weak self] (errorTextString) in
      self?.errorIndicator.isHidden = errorTextString == nil
      self?.errorLabel.text = errorTextString
    }
    viewModel.isRequestNewAuthCodeAllowed.bind { [weak self] (isRequestAllowed) in
      self?.requestNewAuthCodeButton.isHidden = !isRequestAllowed
      self?.retryTimerLabel.isHidden = isRequestAllowed
    }
  }

  // MARK: - Private custom methods
  private func subscribeForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleNotifKeyboardShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleNotifKeyboardHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }

  private func unsubscribeFromNotifications() {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: - Handlers
  @IBAction func handleChangePhoneButtonTap() {
    navigationController?.popViewController(animated: true)
  }

  @IBAction func handleRequestNewAuthCodeButtonTap() {
    viewModel.requestNewAuthCode()
  }

  @objc func handleNotifKeyboardShow(notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    let keyboardSizeKey = UIResponder.keyboardFrameEndUserInfoKey
    guard let keyboardSize = (userInfo[keyboardSizeKey] as? NSValue)?.cgRectValue else { return }
    retryComponentStackBottomConstraint.constant = -(keyboardSize.height + retryComponentStackBottomGap)
  }

  @objc func handleNotifKeyboardHide() {
    retryComponentStackBottomConstraint.constant = -retryComponentStackBottomGap
  }
}

// MARK: - Masked text field delegate listener methods
extension AuthCodeEnterScreenController: MaskedTextFieldDelegateListener {
  func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
    guard complete else { return }
    viewModel.sendAuthCode(value)
    authCodeField.resignFirstResponder()
  }
}

// MARK: - View model delegate methods
extension AuthCodeEnterScreenController: AuthCodeEnterScreenViewModelDelegate {
  func didRegisterUser() {
    performSegue(withIdentifier: "AuthCodeToEnterNameScreenSegue", sender: nil)
  }

  func didLogInUser() {
    performSegue(withIdentifier: "AuthCodeToMainUISegue", sender: nil)
  }
}
