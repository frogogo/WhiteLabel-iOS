//
//  CouponDetailScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 15.05.2021.
//

import UIKit
import Kingfisher

class CouponDetailScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = CouponDetailScreenViewModel()

  @IBOutlet private var mainTable: UITableView!

  private let tableBottomScrollInset: CGFloat = 120
  private let cellReuseIDForSections = [CouponDetailScreenMainInfoCell.reuseID,
                                        CouponDetailScreenInstructionStepCell.reuseID]

  // MARK: - Lifecycle methods
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if type(of: segue.destination) == CouponBarcodeScreenController.self {
      let barcodeVC = segue.destination as! CouponBarcodeScreenController
      barcodeVC.generateBarcode(with: viewModel.barcodeString)
    }
  }

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
    viewModel.delegate = self
  }

  // MARK: - Private custom methods
  private func updateMainInfoCell(_ cell: CouponDetailScreenMainInfoCell) {
    cell.nameLabel.text = viewModel.displayName
    cell.numberLabel.text = viewModel.number
    cell.picture.kf.setImage(with: URL(string: viewModel.pictureURL))
  }

  private func updateInstructionStepCell(_ cell: CouponDetailScreenInstructionStepCell, forRow rowIndex: Int) {
    cell.numberLabel.text = "\(rowIndex + 1)"
    cell.instructionTextLabel.text = viewModel.stepInstructionText(forIndex: rowIndex)
  }

  // MARK: - Handlers
  @IBAction func handleCloseButtonTap() {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - Table data source methods
extension CouponDetailScreenController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return cellReuseIDForSections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let reuseID = cellReuseIDForSections[section]
    if reuseID == CouponDetailScreenInstructionStepCell.reuseID {
      return viewModel.instructionStepsCount
    } else {
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseID = cellReuseIDForSections[indexPath.section]
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)

    switch reuseID {
    case CouponDetailScreenMainInfoCell.reuseID:
      guard let mainInfoCell = cell as? CouponDetailScreenMainInfoCell else { return cell }
      updateMainInfoCell(mainInfoCell)
    case CouponDetailScreenInstructionStepCell.reuseID:
      guard let stepCell = cell as? CouponDetailScreenInstructionStepCell else { return cell }
      updateInstructionStepCell(stepCell, forRow: indexPath.row)
    default:
      return cell
    }
    return cell
  }
}

// MARK: - View model delegate methods
extension CouponDetailScreenController: CouponDetailScreenViewModelDelegate {
  func viewModelUpdated() {
    mainTable.reloadData()
  }
}
