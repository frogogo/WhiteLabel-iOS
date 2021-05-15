//
//  HomeInitialScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 30.04.2021.
//

import Foundation

protocol HomeInitialScreenViewModelDelegate: AnyObject {
  func showHomeEmptyStateScreen()
  func showHomeScreen()
}

class HomeInitialScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: HomeInitialScreenViewModelDelegate?

  // MARK: - Overridden methods
  override func loadInitialData() {
    super.loadInitialData()

    HomeManager.shared.checkHomeData { [weak self] (isHomeDataNotEmpty) in
      // TODO: вернуть нормальную проверку флага ниже!
      //if isHomeDataNotEmpty {
      if false {
        self?.delegate?.showHomeScreen()
      } else {
        self?.delegate?.showHomeEmptyStateScreen()
      }
    } onFailure: { (error) in
      print("Не удалось проверить данные для главной страницы")
    }
  }
}
