//
//  HomeScreenScanWarningCell.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 02.09.2021.
//

import UIKit

class HomeScreenScanWarningCell: UITableViewCell {
  // MARK: - Properties
  @IBOutlet private var container: UIView!
  @IBOutlet private var hintLabel: UILabel!

  // MARK: - Lifecycle methods
  override func awakeFromNib() {
    super.awakeFromNib()
    container.layer.shadowColor = UIColor.black.cgColor
    container.layer.shadowOpacity = 0.1
    container.layer.shadowOffset = CGSize(width: 0, height: 0)
    container.layer.shadowRadius = 8

    setLocalizedTexts()
  }

  // MARK: - Private custom methods
  private func setLocalizedTexts() {
    hintLabel.text = LocalizedString(forKey: "home.home_screen.scan_warning_cell.hint_text")
  }
}
