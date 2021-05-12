//
//  HomeEmptyScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 30.04.2021.
//

import UIKit

class HomeEmptyScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = HomeEmptyScreenViewModel()

  @IBOutlet private var mainTable: UITableView!

  private let tableBottomScrollInset: CGFloat = 120
  private let reuseIDForSections = [HomeEmptyScreenPromotionItemCell.reuseID,
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
  }

  // MARK: - Private custom methods
  private func updateInstructionStepCell(cell: HomeEmptyScreenInstructionStepCell, forRow rowIndex: Int) {
    cell.stepNumberLabel.text = "\(rowIndex + 1)"
  }

  // MARK: - Handlers
  @IBAction func handleScanButtonTap() {
    print("Надо открыть сканер QR кодов")
  }
}

// MARK: - Table data source methods
extension HomeEmptyScreenController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return reuseIDForSections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let reuseID = reuseIDForSections[section]
    if reuseID == HomeEmptyScreenInstructionStepCell.reuseID {
      // TODO: вернуть правильное количество шагов в инструкции
      return 5
    } else {
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseID = reuseIDForSections[indexPath.section]
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)

    switch reuseID {
    case HomeEmptyScreenInstructionStepCell.reuseID:
      guard let stepCell = cell as? HomeEmptyScreenInstructionStepCell else { return cell }
      updateInstructionStepCell(cell: stepCell, forRow: indexPath.row)
    default:
      return cell
    }
    return cell
  }
}
