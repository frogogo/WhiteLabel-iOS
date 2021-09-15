//
//  ReceiptListScreenViewModel.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 28.08.2021.
//

import Foundation

protocol ReceiptListScreenViewModelDelegate: AnyObject {
  func viewModelUpdated()
}

class ReceiptListScreenViewModel: BaseViewModel {
  // MARK: - Properties
  weak var delegate: ReceiptListScreenViewModelDelegate?

  var receiptCount: Int {
    return receiptViewModels.count
  }

  private var receiptViewModels: [ReceiptListReceiptViewModel] = []
  private var receipts: [ReceiptModel] = []

  // MARK: - Overridden methods
  override func refreshData() {
    super.refreshData()

    createReceiptViewModels(forModels: HomeManager.shared.receipts)
    delegate?.viewModelUpdated()
  }

  // MARK: - Internal/public custom methods
  func receiptViewModel(forIndex index: Int) -> ReceiptListReceiptViewModel {
    return receiptViewModels[index]
  }

  func receiptModel(forIndex index: Int) -> ReceiptModel {
    return receipts[index]
  }

  // MARK: - Private custom methods
  private func createReceiptViewModels(forModels receiptModels: [ReceiptModel]) {
    receipts = receiptModels
    receiptViewModels.removeAll()
    for receiptModel in receiptModels {
      receiptViewModels.append(ReceiptListReceiptViewModel(withModel: receiptModel))
    }
  }
}
