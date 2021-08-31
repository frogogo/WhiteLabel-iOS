//
//  ReceiptListReceiptCell.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 14.05.2021.
//

import UIKit

class ReceiptListReceiptCell: UITableViewCell {
  // MARK: - Properties
  var viewModel: ReceiptListReceiptViewModel? {
    didSet {
      addBindings()
    }
  }

  @IBOutlet private var container: UIView!
  @IBOutlet private var sumLabel: UILabel!
  @IBOutlet private var timeLabel: UILabel!
  @IBOutlet private var statusIcon: UIImageView!

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
    viewModel?.sumText.bind { [weak self] sumTextString in
      self?.sumLabel.text = sumTextString
    }
    viewModel?.timeText.bind { [weak self] timeTextString in
      self?.timeLabel.text = timeTextString
    }
    viewModel?.statusIconName.bind { [weak self] iconName in
      self?.statusIcon.image = UIImage(named: iconName)
    }
  }
}
