//
//  HomeScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 14.05.2021.
//

import Foundation

protocol HomeScreenViewModelDelegate: AnyObject {
  func viewModelUpdated()
}

class HomeScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: HomeScreenViewModelDelegate?

  var currentSumText: String {
    return CurrencyHelper.readableSumInRubles(withAmount: couponProgress.currentSum)
  }
  var targetSumText: String {
    return CurrencyHelper.readableSumInRubles(withAmount: couponProgress.targetSum)
  }
  var progressRatio: Float {
    return Float(couponProgress.currentSum) / Float(couponProgress.targetSum)
  }

  var couponCount: Int {
    return couponViewModels.count
  }
  var receiptCount: Int {
    return receiptViewModels.count
  }
  var receiptInProcess = Box(value: false)
  var dataRefreshInProcess = Box(value: false)

  private var couponProgress = CouponProgressModel()
  private var couponViewModels: [HomeScreenCouponViewModel] = []
  private var receiptViewModels: [HomeScreenReceiptViewModel] = []

  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    dataRefreshInProcess.value = true

    HomeManager.shared.refreshHomeData { [weak self] in
      guard let self = self else { return }
      self.couponProgress = HomeManager.shared.couponProgress
      self.createReceiptViewModels(forModels: HomeManager.shared.receipts)
      self.createCouponViewModels(forModels: HomeManager.shared.coupons)
      self.dataRefreshInProcess.value = false
      self.delegate?.viewModelUpdated()

    } onFailure: { [weak self] error in
      self?.dataRefreshInProcess.value = false
    }
  }

  // MARK: - Internal/public custom methods
  func couponViewModel(forIndex index: Int) -> HomeScreenCouponViewModel {
    return couponViewModels[index]
  }

  func receiptViewModel(forIndex index: Int) -> HomeScreenReceiptViewModel {
    return receiptViewModels[index]
  }

  // MARK: - Private custom methods
  private func createReceiptViewModels(forModels receiptModels: [ReceiptModel]) {
    receiptViewModels.removeAll()
    receiptInProcess.value = false

    for receiptModel in receiptModels {
      if receiptModel.state == .processing {
        receiptInProcess.value = true
      }
      receiptViewModels.append(HomeScreenReceiptViewModel(withModel: receiptModel))
    }
  }

  private func createCouponViewModels(forModels couponModels: [CouponModel]) {
    let promotion = HomeManager.shared.promotion

    couponViewModels.removeAll()
    for couponModel in couponModels {
      let couponViewModel = HomeScreenCouponViewModel(withModel: couponModel)
      couponViewModel.titleText.value = promotion.name
      couponViewModel.pictureURL.value = promotion.photo.thumbPhotoURL
      couponViewModels.append(couponViewModel)
    }
  }
}
