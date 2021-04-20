//
//  PhoneEnterScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 20.04.2021.
//

import UIKit

class PhoneEnterScreenController: BaseViewController {
  // MARK: - Properties
  private let viewModel = PhoneEnterScreenViewModel()

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
  }

  override func addBindings() {
    super.addBindings()
  }
}
