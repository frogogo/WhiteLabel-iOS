//
//  HomeEmptyScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 30.04.2021.
//

import UIKit
import Kingfisher

class HomeEmptyScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = HomeEmptyScreenViewModel()

  @IBOutlet private var mainTable: UITableView!

  private let tableBottomScrollInset: CGFloat = 120
  private let cellReuseIDForSections = [HomeEmptyScreenPromotionItemCell.reuseID,
                                        HomeEmptyScreenInstructionHeaderCell.reuseID,
                                        HomeEmptyScreenInstructionStepCell.reuseID]

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
  private func updateInstructionStepCell(_ cell: HomeEmptyScreenInstructionStepCell, forRow rowIndex: Int) {
    cell.stepNumberLabel.text = "\(rowIndex + 1)"
    cell.stepTextLabel.text = viewModel.stepInstructionText(forIndex: rowIndex)
  }

  private func updatePromotionItemCell(_ cell: HomeEmptyScreenPromotionItemCell) {
    cell.nameLabel.text = viewModel.promotionName
    cell.picture.kf.setImage(with: URL(string: viewModel.promotionPictureURL))
  }

  // MARK: - Handlers
  @IBAction func handleScanButtonTap() {
    print("Надо открыть сканер QR кодов")
  }
}

// MARK: - Table data source methods
extension HomeEmptyScreenController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return cellReuseIDForSections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let reuseID = cellReuseIDForSections[section]
    if reuseID == HomeEmptyScreenInstructionStepCell.reuseID {
      return viewModel.promotionStepsCount
    } else {
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseID = cellReuseIDForSections[indexPath.section]
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)

    switch reuseID {
    case HomeEmptyScreenPromotionItemCell.reuseID:
      guard let itemCell = cell as? HomeEmptyScreenPromotionItemCell else { return cell }
      updatePromotionItemCell(itemCell)
    case HomeEmptyScreenInstructionStepCell.reuseID:
      guard let stepCell = cell as? HomeEmptyScreenInstructionStepCell else { return cell }
      updateInstructionStepCell(stepCell, forRow: indexPath.row)
    default:
      return cell
    }
    return cell
  }
}

// MARK: - View model delegate methods
extension HomeEmptyScreenController: HomeEmptyScreenViewModelDelegate {
  func viewModelUpdated() {
    mainTable.reloadData()
  }
}
