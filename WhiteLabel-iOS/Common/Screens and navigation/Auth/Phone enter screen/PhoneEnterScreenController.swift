//
//  PhoneEnterScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 20.04.2021.
//

import UIKit
import InputMask
import NotificationCenter

class PhoneEnterScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = PhoneEnterScreenViewModel()

  @IBOutlet private var phoneCodeLabel: UILabel!
  @IBOutlet private var phoneField: UITextField!
  @IBOutlet private var phoneFieldListener: MaskedTextFieldDelegate!
  @IBOutlet private var activityIndicator: UIActivityIndicatorView!
  @IBOutlet private var errorContainer: UIView!
  @IBOutlet private var errorContainerBottomConstraint: NSLayoutConstraint!
  @IBOutlet private var errorLabel: UILabel!

  private let errorContainerBottomGap: CGFloat = 24

  // MARK: - Lifecycle methods
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    subscribeForKeyboardNotifications()
    phoneField.becomeFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromNotifications()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if segue.identifier == "PhoneEnterToAuthCodeCheckSegue" {
      let destinationVC = segue.destination as? AuthCodeEnterScreenController
      destinationVC?.viewModel.enteredPhoneNumber = viewModel.enteredPhoneNumber
      destinationVC?.viewModel.newAuthCodeRetryDelayInSeconds = viewModel.retryDelayInSeconds
    }
  }
  
  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
    viewModel.delegate = self
  }

  override func addBindings() {
    super.addBindings()

    viewModel.phoneCode.bind { [weak self] (phoneCodeString) in
      self?.phoneCodeLabel.text = phoneCodeString
    }
    viewModel.showActivity.bind { [weak self] (needToShowActivity) in
      if needToShowActivity {
        self?.activityIndicator.startAnimating()
      } else {
        self?.activityIndicator.stopAnimating()
      }
    }
    viewModel.errorToShow.bind { [weak self] (errorToShow) in
      self?.errorContainer.isHidden = errorToShow == nil
      self?.errorLabel.text = errorToShow
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
  @IBAction private func handleRetryButtonTap() {
    viewModel.retryEnteredPhoneSending()
  }

  @objc func handleNotifKeyboardShow(notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    let keyboardSizeKey = UIResponder.keyboardFrameEndUserInfoKey
    guard let keyboardSize = (userInfo[keyboardSizeKey] as? NSValue)?.cgRectValue else { return }

    errorContainerBottomConstraint.constant = -(keyboardSize.height + errorContainerBottomGap)
  }

  @objc func handleNotifKeyboardHide() {
    errorContainerBottomConstraint.constant = -errorContainerBottomGap
  }
}

// MARK: - Masked text field delegate listener methods
extension PhoneEnterScreenController: MaskedTextFieldDelegateListener {
  func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
    guard complete else { return }
    viewModel.sendEnteredPhone(value)
    phoneField.resignFirstResponder()
  }
}

// MARK: - View model delegate methods
extension PhoneEnterScreenController: PhoneEnterScreenViewModelDelegate {
  func didSendEnteredPhone() {
    performSegue(withIdentifier: "PhoneEnterToAuthCodeCheckSegue", sender: nil)
  }
}
