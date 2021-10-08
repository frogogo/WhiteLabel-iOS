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
  @IBOutlet private var scanReceiptButton: UIButton!

  private let pullToRefreshControl = UIRefreshControl()

  private let tableBottomScrollInset: CGFloat = 120
  private let cellReuseIDForSections = [HomeScreenCouponProgressCell.reuseID,
                                        HomeScreenCouponCell.reuseID,
                                        HomeScreenScanWarningCell.reuseID,
                                        HomeScreenSeeReceiptListButtonCell.reuseID,
                                        ProductCell.reuseID]

  private var couponSectionHeader: SectionHeader?
  private var selectedCouponIndex: Int?
  private var productSectionHeader: SectionHeader?
  private var selectedProductIndex: Int?

  // MARK: - Lifecycle methods
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
    viewModel.delegate = self
  }

  override func setupStaticContentForDisplay() {
    super.setupStaticContentForDisplay()
    mainTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableBottomScrollInset, right: 0)
    registerCells()
    setupProductSectionHeader()
    setupRefreshControl()
    scanReceiptButton.setTitle(LocalizedString(forKey: "home.home_screen.scan_button.title"), for: .normal)
  }

  override func addBindings() {
    super.addBindings()

    viewModel.receiptInProcess.bind { [weak self] receiptInProcess in
      self?.scanReceiptButton.isEnabled = !receiptInProcess
    }

    viewModel.dataRefreshInProcess.bind { [weak self] dataRefreshInProcess in
      if dataRefreshInProcess {
        self?.pullToRefreshControl.beginRefreshing()
      } else {
        self?.pullToRefreshControl.endRefreshing()
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    switch segue.identifier {
    case "HomeToCouponDetailsSegue":
      guard let couponVC = segue.destination as? CouponDetailScreenController else { return }
      guard selectedCouponIndex != nil else { return }
      let couponViewModel = viewModel.couponViewModel(forIndex: selectedCouponIndex!)
      couponVC.viewModel.coupon = couponViewModel.couponModel

    case "HomeScreenToProductSegue":
      guard let productScreenVC = segue.destination as? ProductScreenController else { return }
      guard let selectedProductIndex = selectedProductIndex else { return }
      guard let selectedProductID = viewModel.productID(forIndex: selectedProductIndex) else { return }
      productScreenVC.viewModel.productIDForDisplay = selectedProductID

    case "HomeScreenToQRScannerSegue":
      guard let scannerVC = segue.destination as? QRCodeScannerController else { return }
      scannerVC.delegate = self
    default:
      break
    }
  }

  // MARK: - Private custom methods
  private func registerCells() {
    let xibForProductCell = UINib(nibName: ProductCell.xibName, bundle: .main)
    mainTable.register(xibForProductCell, forCellReuseIdentifier: ProductCell.reuseID)
  }

  private func setupRefreshControl() {
    pullToRefreshControl.tintColor = UIColor(named: "PrimaryMain")
    pullToRefreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
    mainTable.refreshControl = pullToRefreshControl
    mainTable.addSubview(pullToRefreshControl)
  }

  private func setupProductSectionHeader() {
    let headerXib = UINib(nibName: "SectionHeader", bundle: .main)
    productSectionHeader = headerXib.instantiate(withOwner: nil, options: nil)[0] as? SectionHeader
    productSectionHeader?.titleLabel.text = LocalizedString(forKey: "home.home_screen.product_section_header.title")
  }

  private func updateCouponProgressCell(_ cell: HomeScreenCouponProgressCell) {
    cell.currentValueLabel.text = viewModel.currentSumText
    cell.targetValueLabel.text = viewModel.targetSumText
    cell.progressBar.progress = viewModel.progressRatio
    cell.progressHintLabel.text = viewModel.progressHintText
  }

  private func preparedCouponSectionHeader() -> SectionHeader {
    if couponSectionHeader == nil {
      let headerXib = UINib(nibName: "SectionHeader", bundle: .main)
      couponSectionHeader = headerXib.instantiate(withOwner: nil, options: nil)[0] as? SectionHeader
      couponSectionHeader?.titleLabel.text = LocalizedString(forKey: "home.home_screen.coupon_section_header.title")
    }
    return couponSectionHeader!
  }

  // MARK: - Handlers
  @objc func handlePullToRefresh() {
    viewModel.refreshData()
  }

  @IBAction func handleProfileButtonTap() {
    performSegue(withIdentifier: "HomeScreenToProfileScreenSegue", sender: nil)
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
    case HomeScreenScanWarningCell.reuseID:
      return viewModel.receiptInProcess.value ? 1 : 0
    case ProductCell.reuseID:
      return viewModel.productCellCount
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
    case ProductCell.reuseID:
      guard let productCell = cell as? ProductCell else { return cell }
      productCell.viewModel = viewModel.productCellViewModel(forIndex: indexPath.row)
      productCell.delegate = self
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
    case ProductCell.reuseID:
      return UITableView.automaticDimension
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let reuseID = cellReuseIDForSections[section]
    switch reuseID {
    case HomeScreenCouponCell.reuseID:
      return viewModel.couponCount > 0 ? preparedCouponSectionHeader() : nil
    case ProductCell.reuseID:
      return productSectionHeader
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

// MARK: - Product cell delegate methods
extension HomeScreenController: ProductCellDelegate {
  func productCell(_ cell: ProductCell, didSelectSlotWithIndex slotIndex: Int) {
    guard let cellIndex = mainTable.indexPath(for: cell)?.row else { return }
    let productIndex = (cellIndex * 2) + slotIndex

    selectedProductIndex = productIndex
    performSegue(withIdentifier: "HomeScreenToProductSegue", sender: nil)
  }
}
