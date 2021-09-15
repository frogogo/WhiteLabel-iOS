//
//  CameraAccessAlertController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 15.05.2021.
//

import UIKit

class CameraAccessAlertController: UIViewController {
  // MARK: - Properties
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var hintLabel: UILabel!
  @IBOutlet private var okButton: UIButton!
  @IBOutlet private var denyButton: UIButton!

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setLocalizedTexts()
  }

  // MARK: - Private custom methods
  private func setLocalizedTexts() {
    titleLabel.text = LocalizedString(forKey: "camera_access_alert.title")
    hintLabel.text = LocalizedString(forKey: "camera_access_alert.hint")
    okButton.setTitle(LocalizedString(forKey: "camera_access_alert.ok_button.title"), for: .normal)
    denyButton.setTitle(LocalizedString(forKey: "camera_access_alert.deny_button.title"), for: .normal)
  }

  // MARK: - Handlers
  @IBAction func handleOKButtonTap() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    dismiss(animated: true, completion: nil)
  }

  @IBAction func handleDenyButtonTap() {
    dismiss(animated: true, completion: nil)
  }
}
