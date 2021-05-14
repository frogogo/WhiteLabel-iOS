//
//  HomeScreenCouponCell.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 14.05.2021.
//

import UIKit

class HomeScreenCouponCell: UITableViewCell {
  // MARK: - Properties
  var viewModel: HomeScreenCouponViewModel? {
    didSet {
      addBindings()
    }
  }

  @IBOutlet private var container: UIView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var numberLabel: UILabel!
  @IBOutlet private var picture: UIImageView!

  // MARK: - Lifecycle methods
  override func awakeFromNib() {
    super.awakeFromNib()
    container.layer.shadowColor = UIColor.black.cgColor
    container.layer.shadowOpacity = 0.1
    container.layer.shadowOffset = CGSize(width: 0, height: 0)
    container.layer.shadowRadius = 8
  }

  // MARK: - Private custom methods
  private func addBindings() {
    viewModel?.titleText.bind { [weak self] titleTextString in
      self?.titleLabel.text = titleTextString
    }
    viewModel?.numberString.bind { [weak self] numberTextString in
      self?.numberLabel.text = numberTextString
    }
    viewModel?.pictureURL.bind { [weak self] pictureURL in
      self?.picture.kf.setImage(with: URL(string: pictureURL))
    }
  }
}
