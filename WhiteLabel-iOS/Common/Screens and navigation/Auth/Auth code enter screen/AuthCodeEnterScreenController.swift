//
//  AuthCodeEnterScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 20.04.2021.
//

import Foundation

class AuthCodeEnterScreenController: BaseViewController {
  // MARK: - Properties
  private let viewModel =  AuthCodeEnterScreenViewModel()

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
  }
}
