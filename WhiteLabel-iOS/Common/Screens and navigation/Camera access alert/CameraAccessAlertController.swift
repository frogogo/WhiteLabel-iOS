//
//  CameraAccessAlertController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 15.05.2021.
//

import UIKit

class CameraAccessAlertController: UIViewController {
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
