//
//  ProductCell.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 09.07.2021.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {
  // MARK: - Properties
  var viewModel: ProductViewModel? {
    didSet {
      updateDisplayedInfo()
    }
  }

  @IBOutlet private var leftSlot: ProductCellSlot!
  @IBOutlet private var rightSlot: ProductCellSlot!

  private var slots: [ProductCellSlot] = []

  // MARK: - Lifecycle methods
  override func awakeFromNib() {
    super.awakeFromNib()
    slots = [leftSlot, rightSlot]
    drawShadow(forSlot: leftSlot)
    drawShadow(forSlot: rightSlot)
  }

  // MARK: - Private custom methods
  private func updateDisplayedInfo() {
    updateSlot(withIndex: 0)

    let needToShowRightSlot = viewModel != nil && viewModel!.needToDisplayRightSlot
    rightSlot.isHidden = !needToShowRightSlot
    if needToShowRightSlot {
      updateSlot(withIndex: 1)
    }
  }

  private func drawShadow(forSlot slot: ProductCellSlot) {
    slot.layer.shadowColor = UIColor.black.cgColor
    slot.layer.shadowOpacity = 0.1
    slot.layer.shadowOffset = CGSize(width: 0, height: 0)
    slot.layer.shadowRadius = 8
  }

  private func updateSlot(withIndex slotIndex: Int) {
    guard let viewModel = self.viewModel else { return }
    let slotToUpdate = slots[slotIndex]

    let pictureURL = viewModel.productPictureURL(forSlot: slotIndex)
    slotToUpdate.picture.kf.setImage(with: URL(string: pictureURL))

    slotToUpdate.nameLabel.text = viewModel.productName(forSlot: slotIndex)
    slotToUpdate.specsLabel.text = viewModel.productSpecs(forSlot: slotIndex)
    slotToUpdate.priceLabel.text = viewModel.productPrice(forSlot: slotIndex)
    slotToUpdate.discountedPriceLabel.text = viewModel.productDiscountedPrice(forSlot: slotIndex)
  }
}
