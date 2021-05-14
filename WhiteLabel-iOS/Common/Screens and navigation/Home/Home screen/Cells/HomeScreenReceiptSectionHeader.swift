//
//  HomeScreenReceiptSectionHeader.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 14.05.2021.
//

import UIKit

class HomeScreenReceiptSectionHeader: UIView {
  // MARK: - Properties
  @IBOutlet private var noticeContainerTopOffset: UIView!
  @IBOutlet private var noticeContainer: UIView!

  // MARK: - Internal/public custom methods
  func setNoticeVisible(to needToShowNotice: Bool) {
    noticeContainer.isHidden = !needToShowNotice
    noticeContainerTopOffset.isHidden = !needToShowNotice
  }
}
