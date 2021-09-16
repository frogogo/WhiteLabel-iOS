//
//  NameEnterScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 28.04.2021.
//

import Foundation

protocol NameEnterScreenViewModelDelegate: AnyObject {
  func didSendEnteredName()
}

class NameEnterScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: NameEnterScreenViewModelDelegate?

  let titleText = LocalizedString(forKey: "auth.name_enter_screen.title")
  let hintText = LocalizedString(forKey: "auth.name_enter_screen.hint")
  let nameEnterFieldPlaceholder = LocalizedString(forKey: "auth.name_enter_screen.name_enter_field.placeholder")
  let continueButtonTitle = LocalizedString(forKey: "auth.name_enter_screen.сontinue_button.title")
  let errorToShow: Box<String?> = Box(value: nil)

  private (set) var enteredName = ""

  // MARK: - Internal/public custom methods
  func setEnteredName(_ enteredNameString: String?) {
    if !isNameValid(enteredNameString) {
      errorToShow.value = LocalizedString(forKey: "auth.name_enter_screen.error.name_is_empty_or_contain_spaces")
    } else {
      enteredName = enteredNameString!
      delegate?.didSendEnteredName()
    }
  }

  // MARK: - Private custom methods
  private func isNameValid(_ nameStringForCheck: String?) -> Bool {
    guard let nameString = nameStringForCheck else {
      return false
    }
    return nameString != ""
  }
}
