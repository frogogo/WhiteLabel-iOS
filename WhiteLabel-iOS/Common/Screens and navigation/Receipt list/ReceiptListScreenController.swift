//
//  ReceiptListScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 28.08.2021.
//

import UIKit

class ReceiptListScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = ReceiptListScreenViewModel()

  @IBOutlet private var mainTable: UITableView!

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
  }
}
