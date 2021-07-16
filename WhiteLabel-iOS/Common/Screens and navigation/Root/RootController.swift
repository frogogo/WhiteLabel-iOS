//
//  RootController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 16.04.2021.
//

import UIKit

class RootController: UIViewController {
  // MARK: - Properties
  private var onboardingController: UIViewController?
  private var authController: UIViewController?
  private var mainUIController: UIViewController?

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    subscribeForNotifications()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tryAutoLogin()
  }

  // MARK: - Private custom methods
  private func tryAutoLogin() {
    AccountManager.shared.tryAutoLogin { [weak self] in
      self?.showMainUI()
      
    } onFailure: { [weak self] in
      if !AccountManager.shared.didUserSeeOnboarding {
        self?.showOnboarding()
      }
      self?.showAuth()
    }
  }

  private func showScreenWithController(_ controllerToShow: UIViewController) {
    navigationController?.popToRootViewController(animated: false)
    dismiss(animated: false, completion: nil)
    for child in children {
      child.view.removeFromSuperview()
      child.removeFromParent()
    }
    addChild(controllerToShow)
    view.addSubview(controllerToShow.view)
  }

  private func initialController(withStoryboardName storyboardName: String) -> UIViewController? {
    let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
    return storyboard.instantiateInitialViewController()
  }

  private func showOnboarding() {
    if onboardingController == nil {
      onboardingController = initialController(withStoryboardName: "Onboarding")
    }

    // this check prevents crash for targets, which may have no onboarding storyboard
    if onboardingController != nil {
      showScreenWithController(onboardingController!)
    } else {
      showAuth()
    }
  }

  private func showAuth() {
    if authController == nil {
      authController = initialController(withStoryboardName: "Auth")
    }
    showScreenWithController(authController!)
  }

  private func showMainUI() {
    if mainUIController == nil {
      mainUIController = initialController(withStoryboardName: "Home")
    }
    showScreenWithController(mainUIController!)
  }

  private func subscribeForNotifications() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self,
                                   selector: #selector(handleNotifAuthRequired),
                                   name: .authorizationRequired,
                                   object: nil)
  }

  // MARK: - Notification handlers
  @objc func handleNotifAuthRequired() {
    print("\(type(of: self)): Auth required, opening auth UI")
    showAuth()
  }
}
