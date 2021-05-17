//
//  CameraAccessChecker.swift
//  WhiteLabel-iOS
//
//  Created by megaorega on 17.05.2021.
//

import Foundation
import AVKit

class CameraAccessChecker {
  static func checkCameraAccess(onGranted: @escaping () -> Void,
                         onDenied: @escaping () -> Void) {
    let currentCameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)

    switch currentCameraAuthStatus {
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { (isGranted) in
        DispatchQueue.main.async {
          if isGranted {
            onGranted()
          }
        }
      }
    case .authorized:
      onGranted()
    default:
      onDenied()
      break
    }
  }
}
