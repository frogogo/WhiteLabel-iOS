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
  private var selectedReceiptIndex: Int?

  // MARK: - Lifecycle methods
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = false
  }

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
    viewModel.delegate = self
  }

  override func setupStaticContentForDisplay() {
    super.setupStaticContentForDisplay()
    title = LocalizedString(forKey: "receipt_list_screen.title")
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ReceiptListScreenToReceiptScreenSegue" {
      guard let receiptVC = segue.destination as? ReceiptScreenController else { return }
      guard selectedReceiptIndex != nil else { return }
      let receiptToShow = viewModel.receiptModel(forIndex: selectedReceiptIndex!)
      receiptVC.viewModel.setReceiptModel(receiptToShow)
    }
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
    selectedReceiptIndex = indexPath.row
    performSegue(withIdentifier: "ReceiptListScreenToReceiptScreenSegue", sender: nil)
  }
}

// MARK: - View model delegate methods
extension ReceiptListScreenController: ReceiptListScreenViewModelDelegate {
  func viewModelUpdated() {
    mainTable.reloadData()
  }
}
