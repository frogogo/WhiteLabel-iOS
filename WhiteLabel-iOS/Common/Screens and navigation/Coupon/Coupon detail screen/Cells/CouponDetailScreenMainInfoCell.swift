//
//  CouponDetailScreenMainInfoCell.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 15.05.2021.
//

import UIKit
protocol CouponDetailScreenMainInfoCellDelegate: AnyObject {
  func didTapShowCodeButton()
}

class CouponDetailScreenMainInfoCell: UITableViewCell {
  // MARK: - Properties
  weak var delegate: CouponDetailScreenMainInfoCellDelegate?

  @IBOutlet var picture: UIImageView!
  @IBOutlet var numberLabel: UILabel!
  @IBOutlet var nameLabel: UILabel!

  // MARK: - Handlers
  @IBAction func handleShowCodeButtonTap() {
    delegate?.didTapShowCodeButton()
  }
}
