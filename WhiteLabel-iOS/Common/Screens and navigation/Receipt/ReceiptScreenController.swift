//
//  ReceiptScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.05.2021.
//

import UIKit

class ReceiptScreenController: BaseViewController {
  // MARK: - Properties
  let viewModel = ReceiptScreenViewModel()

  var onDismiss: () -> Void = {}

  @IBOutlet private var numberLabel: UILabel!
  @IBOutlet private var sumLabel: UILabel!
  @IBOutlet private var dateLabel: UILabel!
  @IBOutlet private var statusHead: UIView!
  @IBOutlet private var statusIcon: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
  }

  override func addBindings() {
    super.addBindings()

    viewModel.numberText.bind { [weak self] (numberTextString) in
      self?.numberLabel.text = numberTextString
    }
    viewModel.sumText.bind { [weak self] (sumTextString) in
      self?.sumLabel.text = sumTextString
    }
    viewModel.dateText.bind { [weak self] (dateTextString) in
      self?.dateLabel.text = dateTextString
    }
    viewModel.statusIconName.bind { [weak self] iconName in
      self?.statusIcon.image = UIImage(named: iconName)
    }
    viewModel.statusColorName.bind { [weak self] colorName in
      self?.statusHead.backgroundColor = UIColor(named: colorName)
    }
    viewModel.statusTitle.bind { [weak self] statusTitle in
      self?.titleLabel.text = statusTitle
    }
    viewModel.statusDescription.bind { [weak self] statusDescription in
      self?.descriptionLabel.text = statusDescription
    }
  }

  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    super.dismiss(animated: flag, completion: completion)
    onDismiss()
  }

  // MARK: - Handlers
  @IBAction func handleCloseButtonTap() {
    self.presentingViewController?.dismiss(animated: true, completion: { [weak self] in
      self?.onDismiss()
    })
  }
}
