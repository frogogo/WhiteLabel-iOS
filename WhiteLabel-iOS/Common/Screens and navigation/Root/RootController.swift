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

  var needAutoLogin = true

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    subscribeForNotifications()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // TODO: Remove check below. This is temporary solution. This check prevents multiple calls of autologin (it occurs after first scan result dismiss)
    if needAutoLogin {
      AccountManager.shared.tryAutoLogin()
      needAutoLogin = false
    }
  }

  // MARK: - Private custom methods
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
                                   selector: #selector(handleNotifAutoLoginOK),
                                   name: .autoLoginOK,
                                   object: nil)
    notificationCenter.addObserver(self,
                                   selector: #selector(handleNotifAuthRequired),
                                   name: .authorizationRequired,
                                   object: nil)
  }

  // MARK: - Notification handlers
  @objc func handleNotifAuthRequired() {
    print("\(type(of: self)): Auth required, opening AUTH UI")
    if AccountManager.shared.didUserSeeOnboarding {
      showAuth()
    } else {
      showOnboarding()
    }
  }

  @objc func handleNotifAutoLoginOK() {
    print("\(type(of: self)): Auto login OK, opening MAIN UI")
    showMainUI()
  }
}
