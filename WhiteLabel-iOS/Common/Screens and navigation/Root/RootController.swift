//
//  RootController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 16.04.2021.
//

import UIKit

class RootController: UIViewController {

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    performSegue(withIdentifier: "RootToAuthSegue", sender: nil)
  }
}
