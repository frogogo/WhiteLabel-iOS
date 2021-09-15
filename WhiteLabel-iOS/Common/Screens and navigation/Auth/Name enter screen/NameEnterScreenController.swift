//
//  NameEnterScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 28.04.2021.
//

import UIKit

class NameEnterScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = NameEnterScreenViewModel()

  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var hintLabel: UILabel!
  @IBOutlet private var nameField: UITextField!
  @IBOutlet private var errorLabel: UILabel!
  @IBOutlet private var errorIndicator: UIImageView!
  @IBOutlet private var continueButton: UIButton!
  @IBOutlet private var continueButtonBottomConstraint: NSLayoutConstraint!

  private let continueButtonBottomGap: CGFloat = 24

  // MARK: - Lifecycle methods
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    subscribeForKeyboardNotifications()
    nameField.becomeFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromNotifications()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    let destinationVC = segue.destination as? EmailEnterScreenController
    destinationVC?.viewModel.setEnteredName(viewModel.enteredName)
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
    nameField.placeholder = viewModel.nameEnterFieldPlaceholder
    continueButton.setTitle(viewModel.continueButtonTitle, for: .normal)
  }

  override func addBindings() {
    super.addBindings()

    viewModel.errorToShow.bind { [weak self] (errorTextString) in
      self?.errorIndicator.isHidden = errorTextString == nil
      self?.errorLabel.text = errorTextString
      if errorTextString != nil && errorTextString != "" {
        self?.nameField.resignFirstResponder()
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
    guard let enteredName = nameField.text else { return }
    viewModel.setEnteredName(enteredName)
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
extension NameEnterScreenController: NameEnterScreenViewModelDelegate {
  func didSendEnteredName() {
    performSegue(withIdentifier: "EnterNameToEnterEmailScreenSegue", sender: nil)
  }
}
