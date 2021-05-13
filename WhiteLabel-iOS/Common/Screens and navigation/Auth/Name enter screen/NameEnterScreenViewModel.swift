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

  private (set) var enteredName = ""

  // MARK: - Internal/public custom methods
  func setEnteredName(_ enteredNameString: String) {
    enteredName = enteredNameString
    delegate?.didSendEnteredName()
  }
}
