//
//  PermissionManager.swift
//  Utility
//
//  Created by Jiyeon on 7/25/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

import RxSwift

/// 권한 상태 확인 및 요청을 위한 클래스
public final class PermissionManager {
  public init() { }
  private let disposeBag = DisposeBag()
  // MARK: - 권한 상태 확인
  
  private var notificationPermission: Observable<Bool> {
    return Observable<Bool>.create { observable in
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        switch settings.authorizationStatus {
        case .notDetermined:
          self.requestNotificationPermission()
            .subscribe(onNext: { isAllowed in
              observable.onNext(isAllowed)
              observable.onCompleted()
            })
            .disposed(by: self.disposeBag)
        case .authorized:
          observable.onNext(true)
          observable.onCompleted()
        default:
          observable.onNext(false)
          observable.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  private var cameraPermission: Observable<Bool> {
    return Observable<Bool>.create { observable in
      let status = AVCaptureDevice.authorizationStatus(for: .video)
      switch status {
      case .notDetermined:
        self.requestCameraPermission()
          .subscribe { isAllowed in
            observable.onNext(isAllowed)
            observable.onCompleted()
          }
          .disposed(by: self.disposeBag)
      case .authorized:
        observable.onNext(true)
        observable.onCompleted()
      default:
        observable.onNext(false)
        observable.onCompleted()
      }
      
      return Disposables.create()
    }
  }
  
  private var photoPermission: Observable<Bool> {
    return Observable<Bool>.create { observable in
      let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
      switch status {
      case .notDetermined:
        self.requestPhotoPermission()
          .subscribe { isAllowed in
            observable.onNext(isAllowed)
            observable.onCompleted()
          }
          .disposed(by: self.disposeBag)
      case .authorized:
        observable.onNext(true)
        observable.onCompleted()
      default:
        observable.onNext(false)
        observable.onCompleted()
      }
     
      return Disposables.create()
    }
  }
  /// 권한 상태 확인 메서드
  ///
  /// 사용예시:
  /// ```swift
  /// button.rx.tap
  ///   .flatMap {
  ///     PermissionManager().chrckPermission(for: .camera)
  ///   }
  ///   .subscribe(with: self) { owner, status in
  ///     ...
  ///   }
  ///   .disposed(by: disposBag())
  public func checkPermission(for type: PermissionType) -> Observable<Bool> {
    switch type {
    case .notification:
      return notificationPermission
    case .camera:
      return cameraPermission
    case .photo:
      return photoPermission
    }
  }
  
  // MARK: - 권한 요청
  
  /// 알림 권한 요청 메서드
  ///
  /// 사용예시:
  /// ```swift
  /// button.rx.tap
  ///   .flatMap {
  ///     PermissionManager().requestNotificationPermission()
  ///   }
  ///   .subscribe(with: self) { owner, _ in
  ///   }
  ///   .disposed(by: disposBag())
  ///
  public func requestNotificationPermission() -> Observable<Bool> {
    Observable<Bool>.create { observable in
      UNUserNotificationCenter.current()
        .requestAuthorization(
          options: [.alert, .sound, .badge]
        ) { isAllow, _ in
          if isAllow {
            print("Push Notification 권한 허용")
          } else {
            print("Push Notification 권한 거부")
          }
          observable.onNext(isAllow)
          observable.onCompleted()
        }
      return Disposables.create()
    }
  }
  
  /// 카메라 권한 요청 메서드
  ///
  /// 사용예시:
  /// ```swift
  /// button.rx.tap
  ///   .flatMap {
  ///     PermissionManager().requestCameraPermission()
  ///   }
  ///   .subscribe(with: self) { owner, _ in
  ///   }
  ///   .disposed(by: disposBag())
  ///
  public func requestCameraPermission() -> Observable<Bool> {
    Observable<Bool>.create { observable in
      AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted {
          print("카메라 권한 허용")
        } else {
          print("카메라 권한 거부")
        }
        observable.onNext(granted)
        observable.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  /// 앨범 권한 요청 메서드
  ///
  /// 사용예시:
  /// ```swift
  /// button.rx.tap
  ///   .flatMap {
  ///     PermissionManager().requestPhotoPermission()
  ///   }
  ///   .subscribe(with: self) { owner, _ in
  ///   }
  ///   .disposed(by: disposBag())
  ///
  public func requestPhotoPermission() -> Observable<Bool> {
    Observable<Bool>.create { observable in
      PHPhotoLibrary.requestAuthorization(for: .addOnly) { state in
        if state == .authorized {
          print("앨범 권한 허용")
          observable.onNext(true)
          observable.onCompleted()
        } else {
          print("앨범 권한 거부")
          observable.onNext(false)
          observable.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
}

public enum PermissionType {
  case notification, camera, photo
}