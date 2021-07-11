//
//  ProductListHintCell.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 09.07.2021.
//

import UIKit

class ProductListHintCell: UITableViewCell {
  // MARK: - Properties
  @IBOutlet private var hintTextLabel: UILabel!

  // MARK: - Overridden methods
  override func awakeFromNib() {
    super.awakeFromNib()

    // TODO: need to add partner specific text below
    hintTextLabel.text = "После того, как ты соберешь товаров на 3300 ₽, получишь купон на покупку электрического чайника Lion Sabatier International за 1 ₽"
  }
}
