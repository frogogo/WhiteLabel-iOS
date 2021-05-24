//
//  QRCodeScannerController.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.05.2021.
//

import UIKit
import AVKit

protocol QRCodeScannerControllerDelegate: AnyObject {
  func didDismissScanResult(for scannerController: QRCodeScannerController)
}

class QRCodeScannerController: BaseViewController {
  // MARK: - Properties
  var viewModel = QRCodeScannerViewModel()
  weak var delegate: QRCodeScannerControllerDelegate?

  private let supportedCodesForScan: [AVMetadataObject.ObjectType] = [.qr]

  @IBOutlet private var cameraPreviewContainer: UIView!
  @IBOutlet private var flashSwitchButton: UIButton!

  private var captureSession = AVCaptureSession()
  private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  private var isFlashSwitchedOn = false

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCameraSession()
    setupCameraPreview()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startCamera()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    stopCamera()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    guard let receiptVC = segue.destination as? ReceiptScreenController else { return }
    guard let newReceipt = viewModel.receipt else { return }
    receiptVC.viewModel.setReceiptModel(newReceipt)
    receiptVC.onDismiss = { [weak self] in
      guard let self = self else { return }
      self.delegate?.didDismissScanResult(for: self)
    }
  }

  // MARK: - Overridden methods
  override func createViewModel() {
    commonTypeViewModel = viewModel
    viewModel.delegate = self
  }

  // MARK: - Private custom methods
  private func setupCameraSession() {
    guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
    do {
      let input = try AVCaptureDeviceInput(device: captureDevice)
      captureSession.addInput(input)
      let captureMetadataOutput = AVCaptureMetadataOutput()
      captureSession.addOutput(captureMetadataOutput)
      captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      captureMetadataOutput.metadataObjectTypes = supportedCodesForScan
    } catch {
      print(error)
      return
    }
  }

  private func setupCameraPreview() {
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
    videoPreviewLayer?.frame = cameraPreviewContainer.layer.bounds
    cameraPreviewContainer.layer.addSublayer(videoPreviewLayer!)
  }

  private func updateFlashSwitchState() {
    let flashButtonIconName = isFlashSwitchedOn ? "iconFlashOn" : "iconFlashOff"
    flashSwitchButton.setImage(UIImage(named: flashButtonIconName), for: .normal)

    guard let device = AVCaptureDevice.default(for: .video) else { return }
    if (device.hasTorch) {
      do {
        try device.lockForConfiguration()
        if !isFlashSwitchedOn {
          device.torchMode = .off
        } else {
          do {
            try device.setTorchModeOn(level: 1.0)
          } catch {
            print(error)
          }
        }
        device.unlockForConfiguration()
      } catch {
        print(error)
      }
    }
  }

  private func startCamera() {
    captureSession.startRunning()
    updateFlashSwitchState()
  }

  private func stopCamera() {
    captureSession.stopRunning()
  }

  // MARK: - Handlers
  @IBAction func handleCloseButtonTap() {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func handleFlashSwitchButtonTap() {
    isFlashSwitchedOn = !isFlashSwitchedOn
    updateFlashSwitchState()
  }

  @IBAction func handleHelpButtonTap() {
    print("Need to show help for QR-code scanning")
  }
}

// MARK: - Camera delegate methods
extension QRCodeScannerController: AVCaptureMetadataOutputObjectsDelegate {
  func metadataOutput(_ output: AVCaptureMetadataOutput,
                      didOutput metadataObjects: [AVMetadataObject],
                      from connection: AVCaptureConnection) {
    guard metadataObjects.count != 0 else { return }
    guard let parsedObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { return }
    guard parsedObject.type == .qr else { return }
    guard let parsedString = parsedObject.stringValue else { return }

    stopCamera()
    viewModel.handleParsedQRCodeString(parsedString)
  }
}

// MARK: View model delegate methods
extension QRCodeScannerController: QRCodeScannerViewModelDelegate {
  func showScanSuccess() {
    performSegue(withIdentifier: "QRCodeScannerToReceiptScreenSegue", sender: nil)
  }

  func showScanError(_ errorText: String) {
    showStandardAlert(withMessage: errorText, onDismiss: { [weak self] in
      self?.startCamera()
    })
  }
}
