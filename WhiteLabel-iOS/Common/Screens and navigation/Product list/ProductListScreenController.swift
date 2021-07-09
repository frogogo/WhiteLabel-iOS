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
                                        ProductListHintCell.reuseID,
                                        ProductCell.reuseID]
  private var productSectionHeader: SectionHeader?

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
    viewModel.delegate = self
  }

  override func setupStaticContentForDisplay() {
    super.setupStaticContentForDisplay()
    registerCells()
    setupProductSectionHeader()
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
      guard let promotionCell = cell as? PromotionItemCell else { return cell }
      promotionCell.viewModel = viewModel.promotionViewModel
    case ProductCell.reuseID:
      guard let productCell = cell as? ProductCell else { return cell }
      productCell.viewModel = viewModel.productViewModel(forIndex: indexPath.row)
    default:
      return cell
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return UITableView.automaticDimension
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
extension ProductListScreenController: ProductListScreenViewModelDelegate {
  func viewModelUpdated() {
    mainTable.reloadData()
  }
}
