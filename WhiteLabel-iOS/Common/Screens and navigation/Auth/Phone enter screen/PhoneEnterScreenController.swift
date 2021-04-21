//
//  PhoneEnterScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 20.04.2021.
//

import UIKit
import InputMask

class PhoneEnterScreenController: BaseViewController {
  // MARK: - Properties
  @IBOutlet private var phoneCodeLabel: UILabel!
  @IBOutlet private var phoneField: UITextField!
  @IBOutlet private var phoneFieldListener: MaskedTextFieldDelegate!
  @IBOutlet private var activityIndicator: UIActivityIndicatorView!

  private let viewModel = PhoneEnterScreenViewModel()

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
  }

  override func addBindings() {
    super.addBindings()

    viewModel.phoneCode.bind { [weak self] (phoneCodeString) in
      self?.phoneCodeLabel.text = phoneCodeString
    }
    viewModel.showActivity.bind { [weak self] (needToShowActivity) in
      if needToShowActivity {
        self?.activityIndicator.startAnimating()
      } else {
        self?.activityIndicator.stopAnimating()
      }
    }
    
  }
}

// MARK: - Masked text field delegate listener methods
extension PhoneEnterScreenController: MaskedTextFieldDelegateListener {
  func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
    guard complete else { return }
    viewModel.setEnteredPhone(value)
    phoneField.resignFirstResponder()
  }
}
