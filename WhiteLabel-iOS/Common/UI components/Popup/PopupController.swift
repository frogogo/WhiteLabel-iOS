//
//  PopupController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 12.10.2021.
//

import Foundation
import UIKit

class PopupController: UIViewController {
  // MARK: - Properties
  var iconName: String?
  var titleText: String?
  var descriptionText: String?
  var okButtonTitleText: String?

  var onDismiss: () -> Void = {}

  @IBOutlet private var icon: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!
  @IBOutlet private var okButton: UIButton!

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()

    titleLabel.text = titleText
    descriptionLabel.text = descriptionText

    if let iconNameToSet = iconName {
      icon.image = UIImage(named: iconNameToSet)
    }
    if okButtonTitleText != nil {
      okButton.setTitle(okButtonTitleText, for: .normal)
    }
  }

  // MARK: - Handlers
  @IBAction func handleOKButtonTap() {
    dismiss(animated: true) { [weak self] in
      self?.onDismiss()
    }
  }
}
