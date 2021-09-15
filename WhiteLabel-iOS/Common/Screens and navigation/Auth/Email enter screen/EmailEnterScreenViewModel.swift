//
//  EmailEnterScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 28.04.2021.
//

import Foundation

protocol EmailEnterScreenViewModelDelegate: AnyObject {
  func didSendEnteredEmail()
}

class EmailEnterScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: EmailEnterScreenViewModelDelegate?

  let hintText = LocalizedString(forKey: "auth.email_enter_screen.hint")
  let emailEnterFieldPlaceholder = LocalizedString(forKey: "auth.email_enter_screen.email_enter_field.placeholder")
  let continueButtonTitle = LocalizedString(forKey: "auth.email_enter_screen.сontinue_button.title")
  let greetings = Box(value: "")
  let errorToShow: Box<String?> = Box(value: nil)

  private var enteredName: String?

  // MARK: - Internal/public custom methods
  func setEnteredName(_ enteredNameString: String) {
    enteredName = enteredNameString
    greetings.value = LocalizedString(forKey: "auth.email_enter_screen.greetings") + "\n\(enteredNameString)!"
  }

  func setEnteredEmail(_ enteredEmailString: String) {
    guard isValidEmail(enteredEmailString) else {
      errorToShow.value = LocalizedString(forKey: "auth.email_enter_screen.error.incorrect_email")
      return
    }

    ProfileManager.shared.update(name: enteredName, email: enteredEmailString) { [weak self] in
      self?.delegate?.didSendEnteredEmail()
    } onFailure: { [weak self] (error) in
      print("Email update error: \(error)")
      self?.errorToShow.value = error
    }
  }

  // MARK: - Private custom methods
  private func isValidEmail(_ emailString: String) -> Bool {
    return emailString.isValidEmail
  }
}
