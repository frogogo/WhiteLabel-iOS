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
    return CurrencyHelper.readableSum(withAmount: couponProgress.currentSum)
  }
  var targetSumText: String {
    return CurrencyHelper.readableSum(withAmount: couponProgress.targetSum)
  }
  var progressRatio: Float {
    return Float(couponProgress.currentSum) / Float(couponProgress.targetSum)
  }
  var progressHintText: String {
    return makeProgressHintText()
  }

  var couponCount: Int {
    return couponViewModels.count
  }
  var productCellCount: Int {
    return productSectionViewModel.productCellCount
  }
  var receiptInProcess = Box(value: false)
  var dataRefreshInProcess = Box(value: false)

  private var couponProgress = CouponProgressModel()
  private var couponViewModels: [HomeScreenCouponViewModel] = []
  private let productSectionViewModel = ProductListScreenViewModel()

  // MARK: - Lifecycle methods
  // MARK: - Lifecycle methods
  override init() {
    super.init()
    productSectionViewModel.delegate = self
  }
  
  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    dataRefreshInProcess.value = true

    HomeManager.shared.refreshHomeData { [weak self] in
      guard let self = self else { return }
      self.couponProgress = HomeManager.shared.couponProgress
      self.checkForProcessingReceipts(withModels: HomeManager.shared.receipts)
      self.createCouponViewModels(forModels: HomeManager.shared.coupons)
      self.dataRefreshInProcess.value = false
      self.delegate?.viewModelUpdated()

    } onFailure: { [weak self] error in
      self?.dataRefreshInProcess.value = false
    }

    productSectionViewModel.refreshData()
  }

  // MARK: - Internal/public custom methods
  func couponViewModel(forIndex index: Int) -> HomeScreenCouponViewModel {
    return couponViewModels[index]
  }

  func productCellViewModel(forIndex index: Int) -> ProductCellViewModel {
    return productSectionViewModel.productViewModel(forIndex: index)
  }

  func productID(forIndex index: Int) -> String? {
    return productSectionViewModel.productID(forIndex: index)
  }

  // MARK: - Private custom methods
  private func checkForProcessingReceipts(withModels receiptModels: [ReceiptModel]) {
    receiptInProcess.value = false

    for receiptModel in receiptModels {
      if receiptModel.state == .processing {
        receiptInProcess.value = true
      }
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

  private func makeProgressHintText() -> String {
    if receiptInProcess.value {
      return LocalizedString(forKey: "home.home_screen.progress_hint_text.searching_for_products")
    } else if couponProgress.currentSum <= 0 {
      return LocalizedString(forKey: "home.home_screen.progress_hint_text.no_promo_products_found")
    } else {
      let sumLeft = CurrencyHelper.readableSum(withAmount: couponProgress.targetSum - couponProgress.currentSum)
      return LocalizedString(forKey: "home.home_screen.progress_hint_text.scan_more", sumLeft)
    }
  }
}

// MARK: - View model delegate methods
extension HomeScreenViewModel: ProductListScreenViewModelDelegate {
  func viewModelUpdated() {
    delegate?.viewModelUpdated()
  }
}
