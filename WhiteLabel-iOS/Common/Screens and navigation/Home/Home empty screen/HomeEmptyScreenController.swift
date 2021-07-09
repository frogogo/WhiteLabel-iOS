//
//  HomeEmptyScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 30.04.2021.
//

import UIKit
import Kingfisher
import AVKit

protocol HomeEmptyScreenControllerDelegate: AnyObject {
  func didFinishFirstQRCodeScan(_ controller: HomeEmptyScreenController)
}

class HomeEmptyScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = HomeEmptyScreenViewModel()
  weak var delegate: HomeEmptyScreenControllerDelegate?

  @IBOutlet private var mainTable: UITableView!

  private let tableBottomScrollInset: CGFloat = 120
  private let cellReuseIDForSections = [PromotionItemCell.reuseID,
                                        HomeEmptyScreenInstructionHeaderCell.reuseID,
                                        HomeEmptyScreenInstructionStepCell.reuseID,
                                        ProductCell.reuseID]
  private var productSectionHeader: SectionHeader?

  // MARK: - Overridden methods
  override func setupStaticContentForDisplay() {
    super.setupStaticContentForDisplay()
    registerCells()
    setupProductSectionHeader()
    mainTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableBottomScrollInset, right: 0)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if segue.identifier == "HomeEmptyScreenToQRScannerSegue" {
      guard let scannerVC = segue.destination as? QRCodeScannerController else { return }
      scannerVC.delegate = self
    }
  }

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
    viewModel.delegate = self
  }

  // MARK: - Private custom methods
  private func registerCells() {
    let xibForPromotionItemCell = UINib(nibName: PromotionItemCell.xibName, bundle: .main)
    mainTable.register(xibForPromotionItemCell, forCellReuseIdentifier: PromotionItemCell.reuseID)

    let xibForProductCell = UINib(nibName: ProductCell.xibName, bundle: .main)
    mainTable.register(xibForProductCell, forCellReuseIdentifier: ProductCell.reuseID)
  }

  private func setupProductSectionHeader() {
    let headerXib = UINib(nibName: "SectionHeader", bundle: .main)
    productSectionHeader = headerXib.instantiate(withOwner: nil, options: nil)[0] as? SectionHeader
    productSectionHeader?.titleLabel.text = "Товары участвующие в акции"
  }

  private func updateInstructionStepCell(_ cell: HomeEmptyScreenInstructionStepCell, forRow rowIndex: Int) {
    cell.stepNumberLabel.text = "\(rowIndex + 1)"
    cell.stepTextLabel.text = viewModel.stepInstructionText(forIndex: rowIndex)
  }

  // MARK: - Handlers
  @IBAction func handleScanButtonTap() {
    CameraAccessChecker.checkCameraAccess { [weak self] in
      self?.performSegue(withIdentifier: "HomeEmptyScreenToQRScannerSegue", sender: nil)
    } onDenied: { [weak self] in
      self?.performSegue(withIdentifier: "HomeEmptyScreenToCameraAccessSegue", sender: nil)
    }
  }
}

// MARK: - Table data source methods
extension HomeEmptyScreenController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return cellReuseIDForSections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let reuseID = cellReuseIDForSections[section]
    switch reuseID {
    case HomeEmptyScreenInstructionStepCell.reuseID:
      return viewModel.promotionStepsCount
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
    case PromotionItemCell.reuseID:
      guard let itemCell = cell as? PromotionItemCell else { return cell }
      itemCell.viewModel = viewModel.promotionViewModel
    case HomeEmptyScreenInstructionStepCell.reuseID:
      guard let stepCell = cell as? HomeEmptyScreenInstructionStepCell else { return cell }
      updateInstructionStepCell(stepCell, forRow: indexPath.row)
    case ProductCell.reuseID:
      guard let productCell = cell as? ProductCell else { return cell }
      productCell.viewModel = viewModel.productViewModel(forIndex: indexPath.row)
    default:
      return cell
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let reuseID = cellReuseIDForSections[section]
    switch reuseID {
    case ProductCell.reuseID:
      return UITableView.automaticDimension
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let reuseID = cellReuseIDForSections[section]
    switch reuseID {
    case ProductCell.reuseID:
      return productSectionHeader
    default:
      return nil
    }
  }
}

// MARK: - View model delegate methods
extension HomeEmptyScreenController: HomeEmptyScreenViewModelDelegate {
  func viewModelUpdated() {
    mainTable.reloadData()
  }
}

// MARK: - QR code scanner controller delegate methods
extension HomeEmptyScreenController: QRCodeScannerControllerDelegate {
  func didDismissScanResult(for scannerController: QRCodeScannerController) {
    scannerController.dismiss(animated: false) { [weak self] in
      guard let self = self else { return }
      self.delegate?.didFinishFirstQRCodeScan(self)
    }
  }
}
