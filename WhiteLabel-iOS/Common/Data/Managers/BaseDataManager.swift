//
//  BaseDataManager.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 22.04.2021.
//

import Foundation

class BaseDataManager {
  // MARK: - Properties
  var apiConnector: APIConnector!

  // MARK: - Internal/public custom methods
  func postNotification(withName notificationName: Notification.Name) {
    NotificationCenter.default.post(Notification(name: notificationName))
  }
}
