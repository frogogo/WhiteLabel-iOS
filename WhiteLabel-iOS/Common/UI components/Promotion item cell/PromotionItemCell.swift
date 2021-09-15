//
//  PromotionItemCell.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 09.07.2021.
//

import UIKit

class PromotionItemCell: UITableViewCell {
  // MARK: - Properties
  var viewModel: PromotionItemViewModel? {
    didSet {
      addBindings()
    }
  }

  @IBOutlet private var couponTagLabel: UILabel!
  @IBOutlet private var nameLabel: UILabel!
  @IBOutlet private var picture: UIImageView!
  @IBOutlet private var priceLabel: UILabel!
  @IBOutlet private var discountedPriceLabel: UILabel!

  // MARK: - Private custom methods
  private func addBindings() {
    viewModel?.couponTagString.bind { [weak self] couponTagString in
      self?.couponTagLabel.text = couponTagString
    }
    viewModel?.pictureURL.bind { [weak self] pictureURL in
      self?.picture.kf.setImage(with: URL(string: pictureURL))
    }
    viewModel?.nameString.bind { [weak self] nameString in
      self?.nameLabel.text = nameString
    }
    viewModel?.priceString.bind { [weak self] priceString in
      self?.priceLabel.text = priceString
    }
    viewModel?.discountedPriceString.bind { [weak self] discountedPriceString in
      self?.discountedPriceLabel.text = discountedPriceString
    }
  }
}
