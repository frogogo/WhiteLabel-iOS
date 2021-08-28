//
//  HomeScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 30.04.2021.
//

import UIKit
import AVKit

class HomeScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = HomeScreenViewModel()

  @IBOutlet private var mainTable: UITableView!
  @IBOutlet private var scanCodeButton: UIButton!

  private let pullToRefreshControl = UIRefreshControl()

  private let tableBottomScrollInset: CGFloat = 120
  private let cellReuseIDForSections = [HomeScreenCouponProgressCell.reuseID,
                                        HomeScreenCouponCell.reuseID,
                                        HomeScreenSeeReceiptListButtonCell.reuseID]

  private var couponSectionHeader: SectionHeader?
  private var selectedCouponIndex: Int?

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    mainTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableBottomScrollInset, right: 0)
    setupRefreshControl()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if segue.identifier == "HomeToCouponDetailsSegue" {
      guard let couponVC = segue.destination as? CouponDetailScreenController else { return }
      guard selectedCouponIndex != nil else { return }
      let couponViewModel = viewModel.couponViewModel(forIndex: selectedCouponIndex!)
      couponVC.viewModel.coupon = couponViewModel.couponModel

    } else if segue.identifier == "HomeScreenToQRScannerSegue" {
      guard let scannerVC = segue.destination as? QRCodeScannerController else { return }
      scannerVC.delegate = self

    } else if segue.identifier == "HomeScreenToReceiptScreenSegue" {
      // TODO: этот код нужно переместить в контроллер экрана со списком чеков
      //guard let receiptVC = segue.destination as? ReceiptScreenController else { return }
      //guard selectedReceiptIndex != nil else { return }
      //let receiptToShow = viewModel.receipt(forIndex: selectedReceiptIndex!)
      //receiptVC.viewModel.setReceiptModel(receiptToShow)
    }
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

    viewModel.dataRefreshInProcess.bind { [weak self] dataRefreshInProcess in
      if dataRefreshInProcess {
        self?.pullToRefreshControl.beginRefreshing()
      } else {
        self?.pullToRefreshControl.endRefreshing()
      }
    }
  }

  // MARK: - Private custom methods
  private func setupRefreshControl() {
    pullToRefreshControl.tintColor = UIColor(named: "PrimaryMain")
    pullToRefreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
    mainTable.refreshControl = pullToRefreshControl
    mainTable.addSubview(pullToRefreshControl)
  }

  private func updateCouponProgressCell(_ cell: HomeScreenCouponProgressCell) {
    cell.currentValueLabel.text = viewModel.currentSumText
    cell.targetValueLabel.text = viewModel.targetSumText
    cell.progressBar.progress = viewModel.progressRatio
  }

  private func preparedCouponSectionHeader() -> SectionHeader {
    if couponSectionHeader == nil {
      let headerXib = UINib(nibName: "SectionHeader", bundle: .main)
      couponSectionHeader = headerXib.instantiate(withOwner: nil, options: nil)[0] as? SectionHeader
      couponSectionHeader?.titleLabel.text = "Купоны"
    }
    return couponSectionHeader!
  }

  // MARK: - Handlers
  @objc func handlePullToRefresh() {
    viewModel.refreshData()
  }

  @IBAction func handleScanButtonTap() {
    CameraAccessChecker.checkCameraAccess { [weak self] in
      self?.performSegue(withIdentifier: "HomeScreenToQRScannerSegue", sender: nil)
    } onDenied: { [weak self] in
      self?.performSegue(withIdentifier: "HomeScreenToCameraAccessSegue", sender: nil)
    }
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
    default:
      return cell
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let reuseID = cellReuseIDForSections[indexPath.section]

    switch reuseID {
    case HomeScreenSeeReceiptListButtonCell.reuseID:
      performSegue(withIdentifier: "HomeScreenToReceiptListScreenSegue", sender: nil)
    case HomeScreenCouponCell.reuseID:
      selectedCouponIndex = indexPath.row
      performSegue(withIdentifier: "HomeToCouponDetailsSegue", sender: nil)
    default:
      break
    }
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let reuseID = cellReuseIDForSections[section]
    switch reuseID {
    case HomeScreenCouponCell.reuseID:
      return viewModel.couponCount > 0 ? UITableView.automaticDimension : 0
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let reuseID = cellReuseIDForSections[section]
    switch reuseID {
    case HomeScreenCouponCell.reuseID:
      return viewModel.couponCount > 0 ? preparedCouponSectionHeader() : nil
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

// MARK: - QR code scanner controller delegate methods
extension HomeScreenController: QRCodeScannerControllerDelegate {
  func didDismissScanResult(for scannerController: QRCodeScannerController) {
    scannerController.dismiss(animated: true, completion: nil)
  }
}
