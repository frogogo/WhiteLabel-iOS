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
    viewModel.delegate = self
  }
}

// MARK: - Table data source methods
extension ReceiptListScreenController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.receiptCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReceiptListReceiptCell.reuseID, for: indexPath)
    guard let receiptCell = cell as? ReceiptListReceiptCell else { return cell }
    receiptCell.viewModel = viewModel.receiptViewModel(forIndex: indexPath.row)

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedIndex = indexPath.row
    print("Надо открыть чек с индексом \(selectedIndex)")
  }
}

// MARK: - View model delegate methods
extension ReceiptListScreenController: ReceiptListScreenViewModelDelegate {
  func viewModelUpdated() {
    mainTable.reloadData()
  }
}
