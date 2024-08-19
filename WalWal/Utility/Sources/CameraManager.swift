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
  private var currentCameraPosition: AVCaptureDevice.Position
  private var photoOutput: AVCapturePhotoOutput
  
  // 사진 촬영 결과를 방출하는 PublishSubject
  public let photoCapturedSubject = PublishSubject<UIImage>()
  
  public override init() {
    self.captureSession = AVCaptureSession()
    self.currentCameraPosition = .back
    self.photoOutput = AVCapturePhotoOutput()
    super.init()
  }
  
  // 카메라 세션 설정
  public func setupCamera() {
    captureSession.beginConfiguration()
    
    guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCameraPosition),
          let input = try? AVCaptureDeviceInput(device: camera) else {
      return
    }
    
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
    captureSession.startRunning()
  }
  
  // 사진 촬영
  public func capturePhoto() {
    let settings = AVCapturePhotoSettings()
    photoOutput.capturePhoto(with: settings, delegate: self)
  }
  
  // 카메라 세션 시작
  public func startSession() {
    if !captureSession.isRunning {
      captureSession.startRunning()
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
    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.bounds
    previewLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(previewLayer)
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
