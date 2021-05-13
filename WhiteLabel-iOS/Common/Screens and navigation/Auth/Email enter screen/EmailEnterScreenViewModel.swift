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

  let greetings = Box(value: "")
  let errorToShow: Box<String?> = Box(value: nil)

  private var enteredName: String?

  // MARK: - Internal/public custom methods
  func setEnteredName(_ enteredNameString: String) {
    enteredName = enteredNameString
    greetings.value = "Отлично,\n\(enteredNameString)!"
  }

  func setEnteredEmail(_ enteredEmailString: String) {
    print("Надо отправить на сервер имя \(enteredName) и email \(enteredEmailString)")
    // TODO: тут надо сделать валидацию и отправить емейл на сервер
    // TODO: показать ошибку, если валидация не прошла

    ProfileManager.shared.update(name: enteredName, email: enteredEmailString) { [weak self] in
      self?.delegate?.didSendEnteredEmail()
    } onFailure: { [weak self] (error) in
      print("Не удалось обновить email: \(error)")
      self?.errorToShow.value = error
    }
  }
}
