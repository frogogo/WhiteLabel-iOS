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
  @IBOutlet private var scanCodeButton: UIButton!

  private let tableBottomScrollInset: CGFloat = 120
  private let cellReuseIDForSections = [HomeScreenCouponProgressCell.reuseID,
                                        HomeScreenCouponCell.reuseID,
                                        HomeScreenReceiptCell.reuseID]

  private var couponSectionHeader: HomeScreenCouponSectionHeader?
  private var receiptSectionHeader: HomeScreenReceiptSectionHeader?

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

  override func addBindings() {
    super.addBindings()

    viewModel.receiptInProcess.bind { [weak self] receiptInProcess in
      self?.scanCodeButton.isEnabled = !receiptInProcess
    }
  }

  // MARK: - Private custom methods
  private func updateCouponProgressCell(_ cell: HomeScreenCouponProgressCell) {
    cell.currentValueLabel.text = viewModel.currentSumText
    cell.targetValueLabel.text = viewModel.targetSumText
    cell.progressBar.progress = viewModel.progressRatio
  }

  private func preparedCouponSectionHeader() -> HomeScreenCouponSectionHeader {
    if couponSectionHeader == nil {
      let headerXib = UINib(nibName: "HomeScreenCouponSectionHeader", bundle: .main)
      couponSectionHeader = headerXib.instantiate(withOwner: nil, options: nil)[0] as? HomeScreenCouponSectionHeader
    }
    return couponSectionHeader!
  }

  private func preparedReceiptSectionHeader() -> HomeScreenReceiptSectionHeader {
    if receiptSectionHeader == nil {
      let headerXib = UINib(nibName: "HomeScreenReceiptSectionHeader", bundle: .main)
      receiptSectionHeader = headerXib.instantiate(withOwner: nil, options: nil)[0] as? HomeScreenReceiptSectionHeader
    }
    return receiptSectionHeader!
  }
}

// MARK: - Table data source methods
extension HomeScreenController: UITableViewDataSource, UITableViewDelegate {
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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let reuseID = cellReuseIDForSections[indexPath.section]
    if reuseID == HomeScreenCouponCell.reuseID {
      print("Надо открыть купон с индексом \(indexPath.row)")
    }
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let reuseID = cellReuseIDForSections[section]
    switch reuseID {
    case HomeScreenCouponCell.reuseID:
      return UITableView.automaticDimension
    case HomeScreenReceiptCell.reuseID:
      return UITableView.automaticDimension
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let reuseID = cellReuseIDForSections[section]
    switch reuseID {
    case HomeScreenCouponCell.reuseID:
      return preparedCouponSectionHeader()
    case HomeScreenReceiptCell.reuseID:
      let header = preparedReceiptSectionHeader()
      header.setNoticeVisible(to: viewModel.receiptInProcess.value)
      return header
    default:
      return nil
    }
  }
}

// MARK: - View model delegate methods
extension HomeScreenController: HomeScreenViewModelDelegate {
  func viewModelUpdated() {
    mainTable.reloadData()
  }
}
