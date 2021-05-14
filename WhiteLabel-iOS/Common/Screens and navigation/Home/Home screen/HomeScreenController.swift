//
//  HomeScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 30.04.2021.
//

import UIKit

class HomeScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = HomeScreenViewModel()

  @IBOutlet private var mainTable: UITableView!

  private let tableBottomScrollInset: CGFloat = 120
  private let cellReuseIDForSections = [HomeScreenCouponProgressCell.reuseID,
                                        HomeScreenCouponCell.reuseID,
                                        HomeScreenReceiptCell.reuseID]

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    mainTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableBottomScrollInset, right: 0)
  }

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
    viewModel.delegate = self
  }

  // MARK: - Private custom methods
  private func updateCouponProgressCell(_ cell: HomeScreenCouponProgressCell) {
    cell.currentValueLabel.text = viewModel.currentSumText
    cell.targetValueLabel.text = viewModel.targetSumText
    cell.progressBar.progress = viewModel.progressRatio
  }
}

// MARK: - Table data source methods
extension HomeScreenController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return cellReuseIDForSections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let reuseID = cellReuseIDForSections[section]
    switch reuseID {
    case HomeScreenCouponCell.reuseID:
      return viewModel.couponCount
    case HomeScreenReceiptCell.reuseID:
      return viewModel.receiptCount
    default:
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseID = cellReuseIDForSections[indexPath.section]
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)

    switch reuseID {
    case HomeScreenCouponProgressCell.reuseID:
      guard let progressCell = cell as? HomeScreenCouponProgressCell else { return cell }
      updateCouponProgressCell(progressCell)
    case HomeScreenCouponCell.reuseID:
      guard let couponCell = cell as? HomeScreenCouponCell else { return cell }
      couponCell.viewModel = viewModel.couponViewModel(forIndex: indexPath.row)
    case HomeScreenReceiptCell.reuseID:
      guard let receiptCell = cell as? HomeScreenReceiptCell else { return cell }
      receiptCell.viewModel = viewModel.receiptViewModel(forIndex: indexPath.row)
    default:
      return cell
    }
    return cell
  }
}

// MARK: - View model delegate methods
extension HomeScreenController: HomeScreenViewModelDelegate {
  func viewModelUpdated() {
    mainTable.reloadData()
  }
}
