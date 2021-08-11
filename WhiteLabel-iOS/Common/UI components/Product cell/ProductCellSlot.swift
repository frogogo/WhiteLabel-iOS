//
//  ProductCellSlot.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 09.07.2021.
//

import UIKit

protocol ProductCellSlotDelegate: AnyObject {
  func productCellSlotDidTap(_ slot: ProductCellSlot)
}

class ProductCellSlot: UIView {
  // MARK: - Properties
  weak var delegate: ProductCellSlotDelegate?

  @IBOutlet var picture: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var specsLabel: UILabel!
  @IBOutlet var priceLabel: UILabel!
  @IBOutlet var discountedPriceLabel: UILabel!

  // MARK: - Handlers
  @IBAction func tapHandler() {
    delegate?.productCellSlotDidTap(self)
  }
}
