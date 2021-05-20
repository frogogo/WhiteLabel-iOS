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

  let errorToShow: Box<String?> = Box(value: nil)

  private (set) var enteredName = ""

  // MARK: - Internal/public custom methods
  func setEnteredName(_ enteredNameString: String) {
    if isNameValid(enteredNameString) {
      enteredName = enteredNameString
      delegate?.didSendEnteredName()
    } else {
      // TODO: need localization
      errorToShow.value = "Имя не должно быть пустым и содержать пробелы"
    }
  }

  // MARK: - Private custom methods
  private func isNameValid(_ nameString: String) -> Bool {
    return nameString != "" && !nameString.contains(" ")
  }
}
