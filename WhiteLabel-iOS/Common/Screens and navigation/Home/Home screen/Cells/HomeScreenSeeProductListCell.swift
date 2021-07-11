//
//  HomeScreenSeeProductListCell.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 08.07.2021.
//

import UIKit

class HomeScreenSeeProductListCell: UITableViewCell {
  // MARK: - Properties
  @IBOutlet private var container:UIView!
  
  // MARK: - Lifecycle methods
  override func awakeFromNib() {
    super.awakeFromNib()
    container.layer.shadowColor = UIColor.black.cgColor
    container.layer.shadowOpacity = 0.1
    container.layer.shadowOffset = CGSize(width: 0, height: 0)
    container.layer.shadowRadius = 8
  }

  // MARK: - Overridden methods
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    container.alpha = highlighted ? 0.7 : 1
  }
}
