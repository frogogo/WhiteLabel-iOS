//
//  PopupController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 12.10.2021.
//

import Foundation
import UIKit

class PopupController: UIViewController {
  // MARK: - Handlers
  @IBAction func handleOKButtonTap() {
    dismiss(animated: true, completion: nil)
  }
}
