//
//  CameraManager.swift
//  Utility
//
//  Created by 조용인 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import AVFoundation
import RxSwift
import UIKit

public final class CameraManager: NSObject {
  private var captureSession: AVCaptureSession
  public private(set) var captureDevice: AVCaptureDevice?
  private var currentCameraPosition: AVCaptureDevice.Position
  private var photoOutput: AVCapturePhotoOutput
  
  // 사진 촬영 결과를 방출하는 PublishSubject
  public let photoCapturedSubject = PublishSubject<UIImage>()
  
  public override init() {
    self.captureSession = AVCaptureSession()
    self.currentCameraPosition = .back
    self.photoOutput = AVCapturePhotoOutput()
    super.init()
    setupCamera()
  }
  
  // 카메라 세션 설정
  private func setupCamera() {
    captureSession.beginConfiguration()
    
    guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCameraPosition),
          let input = try? AVCaptureDeviceInput(device: camera) else {
      captureSession.commitConfiguration()
      return
    }
    
    captureDevice = camera
    
    captureSession.inputs.forEach { captureSession.removeInput($0) }
    if captureSession.canAddInput(input) {
      captureSession.addInput(input)
    }
    
    if captureSession.canAddOutput(photoOutput) {
      captureSession.addOutput(photoOutput)
    }
    
    captureSession.commitConfiguration()
  }
  
  // 카메라 전환
  public func switchCamera() {
    captureSession.stopRunning()
    currentCameraPosition = currentCameraPosition == .back ? .front : .back
    setupCamera()
    startSession()
  }
  
  // 사진 촬영
  public func capturePhoto() {
    let settings = AVCapturePhotoSettings()
    photoOutput.capturePhoto(with: settings, delegate: self)
  }
  
  // 카메라 세션 시작
  public func startSession() {
    if !captureSession.isRunning {
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        self?.captureSession.startRunning()
      }
    }
  }
  
  // 카메라 세션 종료
  public func stopSession() {
    if captureSession.isRunning {
      captureSession.stopRunning()
    }
  }
  
  // 카메라 프리뷰 설정
  public func attachPreview(to view: UIView) {
    DispatchQueue.main.async {
      let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
      previewLayer.frame = view.bounds
      previewLayer.videoGravity = .resizeAspectFill
      view.layer.addSublayer(previewLayer)
    }
  }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraManager: AVCapturePhotoCaptureDelegate {
  public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    guard let imageData = photo.fileDataRepresentation(),
          let image = UIImage(data: imageData) else {
      return
    }
    // Rx를 통해 촬영된 사진을 방출
    photoCapturedSubject.onNext(image)
  }
}
