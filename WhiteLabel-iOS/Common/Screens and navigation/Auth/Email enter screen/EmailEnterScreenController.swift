//
//  EmailEnterScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 28.04.2021.
//

import UIKit

class EmailEnterScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = EmailEnterScreenViewModel()

  @IBOutlet private var greetingsLabel: UILabel!
  @IBOutlet private var hintLabel: UILabel!
  @IBOutlet private var emailField: UITextField!
  @IBOutlet private var errorLabel: UILabel!
  @IBOutlet private var errorIndicator: UIImageView!
  @IBOutlet private var continueButton: UIButton!
  @IBOutlet private var continueButtonBottomConstraint: NSLayoutConstraint!

  private let continueButtonBottomGap: CGFloat = 24

  // MARK: - Lifecycle methods
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    subscribeForKeyboardNotifications()
    emailField.becomeFirstResponder()
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

    hintLabel.text = viewModel.hintText
    emailField.placeholder = viewModel.emailEnterFieldPlaceholder
    continueButton.setTitle(viewModel.continueButtonTitle, for: .normal)
  }

  override func addBindings() {
    super.addBindings()

    viewModel.greetings.bind { [weak self] (greetingsString) in
      self?.greetingsLabel.text = greetingsString
    }
    viewModel.errorToShow.bind { [weak self] (errorTextString) in
      self?.errorIndicator.isHidden = errorTextString == nil
      self?.errorLabel.text = errorTextString
      if errorTextString != nil && errorTextString != "" {
        self?.emailField.resignFirstResponder()
      }
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
  @IBAction func handleContinueButtonTap() {
    guard let enteredEmail = emailField.text else { return }
    viewModel.setEnteredEmail(enteredEmail)
  }

  @objc func handleNotifKeyboardShow(notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    let keyboardSizeKey = UIResponder.keyboardFrameEndUserInfoKey
    guard let keyboardSize = (userInfo[keyboardSizeKey] as? NSValue)?.cgRectValue else { return }
    continueButtonBottomConstraint.constant = -(keyboardSize.height + continueButtonBottomGap)
    viewModel.errorToShow.value = nil
  }

  @objc func handleNotifKeyboardHide() {
    continueButtonBottomConstraint.constant = -continueButtonBottomGap
  }
}

// MARK: - View model delegate methods
extension EmailEnterScreenController: EmailEnterScreenViewModelDelegate {
  func didSendEnteredEmail() {
    performSegue(withIdentifier: "EnterEmailToMainUISegue", sender: nil)
  }
}
