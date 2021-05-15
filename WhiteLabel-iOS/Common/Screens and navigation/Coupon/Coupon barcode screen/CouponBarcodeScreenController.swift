//
//  CouponBarcodeScreenController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 15.05.2021.
//

import UIKit

class CouponBarcodeScreenController: UIViewController {
  // MARK: - Properties
  @IBOutlet private var barcodeImage: UIImageView!

  private var generatedBarcodeCIImage: CIImage!

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    tryToSetBarcodeImage()
  }

  // MARK: - Internal/public custom methods
  func generateBarcode(with barcodeString: String) {
    let data = barcodeString.data(using: .ascii)
    guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
      return
    }
    filter.setValue(data, forKey: "inputMessage")

    guard let generatedImage = filter.outputImage else { return }
    let transform = CGAffineTransform(scaleX: 5, y: 5)
    generatedBarcodeCIImage = generatedImage.transformed(by: transform)

    tryToSetBarcodeImage()
  }

  // MARK: - Private custom methods
  private func tryToSetBarcodeImage() {
    guard barcodeImage != nil else { return }
    guard generatedBarcodeCIImage != nil else { return }

    barcodeImage.image = UIImage(ciImage: generatedBarcodeCIImage)
  }

  // MARK: - Handlers
  @IBAction func handleCloseButtonTap() {
    dismiss(animated: true, completion: nil)
  }
}
