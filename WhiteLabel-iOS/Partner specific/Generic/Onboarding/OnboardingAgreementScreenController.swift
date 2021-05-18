//
//  OnboardingAgreementScreenController.swift
//  Generic
//
//  Created by megaorega on 18.05.2021.
//

import UIKit

class OnboardingAgreementScreenController: UIViewController {
  // MARK: - Handlers
  @IBAction func handleAcceptButtonTap() {
    AccountManager.shared.registerUserDidSeeOnboarding()
  }
}
