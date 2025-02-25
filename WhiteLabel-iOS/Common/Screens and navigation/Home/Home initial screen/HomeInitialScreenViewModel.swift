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
      if isHomeDataNotEmpty {
        self?.delegate?.showHomeScreen()
      } else {
        self?.delegate?.showHomeEmptyStateScreen()
      }
    } onFailure: { (error) in
      print("Home data check error: \(error)")
    }
  }
}
