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

    // TODO: тут надо отправить запрос, проверить, есть ли данные и вызвать правильный метод делегата
    let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {[weak self] (timer) in
      timer.invalidate()
      //self?.delegate?.showHomeScreen()
      self?.delegate?.showHomeEmptyStateScreen()
    }
  }
}
