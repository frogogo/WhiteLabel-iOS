//
//  ProductListScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 08.07.2021.
//

import UIKit

class ProductListScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = ProductListScreenViewModel()

  @IBOutlet private var mainTable: UITableView!

  private let cellReuseIDForSections = [PromotionItemCell.reuseID,
                                        ProductListHintCell.reuseID
                                        ]

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCells()
  }

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
  }

  private func registerCells() {
    let xibForPromotionItemCell = UINib(nibName: PromotionItemCell.xibName, bundle: .main)
    mainTable.register(xibForPromotionItemCell, forCellReuseIdentifier: PromotionItemCell.reuseID)
  }

  // MARK: - Handlers
  @IBAction func closeButtonTap() {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - Table data source methods
extension ProductListScreenController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return cellReuseIDForSections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let reuseID = cellReuseIDForSections[section]
    switch reuseID {
    case ProductSlotCell.reuseID:
      // TODO: need to count rows correctly
      return 2
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
    case ProductSlotCell.reuseID:
      // TODO: need to set viewmodel for cell
      print("Need to set viewmodel here")
    default:
      return cell
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    // TODO: need to return proper header for section
    return nil
  }
}
