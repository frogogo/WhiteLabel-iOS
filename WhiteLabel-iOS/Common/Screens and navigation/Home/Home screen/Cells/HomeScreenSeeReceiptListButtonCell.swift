//
//  HomeScreenSeeReceiptListButtonCell.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 08.07.2021.
//

import UIKit

class HomeScreenSeeReceiptListButtonCell: UITableViewCell {
  // MARK: - Properties
  @IBOutlet private var container: UIView!
  @IBOutlet private var titleLabel: UILabel!
  
  // MARK: - Lifecycle methods
  override func awakeFromNib() {
    super.awakeFromNib()
    container.layer.shadowColor = UIColor.black.cgColor
    container.layer.shadowOpacity = 0.1
    container.layer.shadowOffset = CGSize(width: 0, height: 0)
    container.layer.shadowRadius = 8

    setLocalizedTexts()
  }

  // MARK: - Overridden methods
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    container.alpha = highlighted ? 0.7 : 1
  }

  // MARK: - Private custom methods
  private func setLocalizedTexts() {
    titleLabel.text = LocalizedString(forKey: "home.home_screen.see_receipt_list_button.title")
  }
}
