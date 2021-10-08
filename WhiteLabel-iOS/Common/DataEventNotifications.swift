//
//  CustomNotifications.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.06.2021.
//

import Foundation

extension Notification.Name {
  // MARK: Auth related notifications
  static let autoLoginOK = Notification.Name("autoLoginOK")
  static let authorizationRequired = Notification.Name("authorizationRequired")

  // MARK: Data event notifications
  static let newCouponOccured = Notification.Name("newCouponOccured")
}
