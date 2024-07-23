//
//  PermissionHelper.swift
//  OnboardingPresenterImp
//
//  Created by Jiyeon on 7/22/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

import RxSwift

/// 권한 요청 및 상태 관련 클래스
public final class PermissionHelper {
  
  public init() { }
  
  // MARK: - 권한 상태 확인 프로퍼티
  
  /// 알림 권한 상태를 확인할 수 있는 메서드
  ///
  /// 사용예시:
  /// ```swift
  ///button.rx.tap
  ///   .flatMap {
  ///     PermissionHelper().notificationPermission
  ///   }
  ///   .subscrive(with: self) { owner, stauts in
  ///     if status == true {
  ///       ... // 알림 권한 허용 상태 처리
  ///     } else {
  ///       ... // 알림 권한 허용 상태 처리
  ///     }
  ///   }
  ///   .dispose(by: disposBag())
  ///
  public var notificationPermission: Observable<Bool> {
    return Observable<Bool>.create { observer in
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        let isAuthorized = settings.authorizationStatus == .authorized
        observer.onNext(isAuthorized)
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  /// 카메라 권한 상태를 확인할 수 있는 메서드
  ///
  /// 사용예시:
  /// ```swift
  ///cameraButton.rx.tap
  ///   .flatMap {
  ///     PermissionHelper().cameraPermission
  ///   }
  ///   .subscrive(with: self) { owner, stauts in
  ///     if status == true {
  ///       ... // 카메라 권한 허용 상태 처리
  ///     } else {
  ///       ... // 카메라 권한 허용 상태 처리
  ///     }
  ///   }
  ///   .dispose(by: disposBag())
  ///
  public var cameraPermission: Observable<Bool> {
    return Observable<Bool>.create { observable in
      let status = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
      observable.onNext(status)
      observable.onCompleted()
      return Disposables.create()
    }
  }
  
  /// 앨범 권한 상태를 확인할 수 있는 메서드
  ///
  /// 사용예시:
  /// ```swift
  ///photoButton.rx.tap
  ///   .flatMap {
  ///     PermissionHelper().photoPermission
  ///   }
  ///   .subscrive(with: self) { owner, stauts in
  ///     if status == true {
  ///       ... // 앨범 권한 허용 상태 처리
  ///     } else {
  ///       ... // 앨범 권한 허용 상태 처리
  ///     }
  ///   }
  ///   .dispose(by: disposBag())
  ///
  public var photoPermission: Observable<Bool> {
    return Observable<Bool>.create { observable in
      let status = PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized
      observable.onNext(status)
      observable.onCompleted()
      return Disposables.create()
    }
  }
  
  // MARK: - 권한 요청 메서드
  
  /// 알림 권한 요청 메서드
  ///
  /// 온보딩에서 최초 요청시에 사용하게 됩니다.
  ///
  /// 사용예시:
  /// ```swift
  /// button.rx.tap
  ///   .flatMap {
  ///     PermissionHelpler().requestNotificationPermission()
  ///   }
  ///   .subscribe(with: self) { owner, _ in
  ///   }
  ///   .disposed(by: disposBag())
  ///
  public func requestNotificationPermission() -> Observable<Void> {
    Observable<Void>.create { observable in
      UNUserNotificationCenter.current()
        .requestAuthorization(
          options: [.alert, .sound, .badge]
        ) { isAllow, _ in
          if isAllow {
            print("Push Notification 권한 허용")
          } else {
            print("Push Notification 권한 거부")
          }
          observable.onNext(())
          observable.onCompleted()
        }
      return Disposables.create()
    }
  }
  
  /// 카메라 권한 요청 메서드
  ///
  /// 온보딩에서 최초 요청시에 사용하게 됩니다.
  ///
  /// 사용예시:
  /// ```swift
  /// button.rx.tap
  ///   .flatMap {
  ///     PermissionHelpler().requestCameraPermission()
  ///   }
  ///   .subscribe(with: self) { owner, _ in
  ///   }
  ///   .disposed(by: disposBag())
  ///
  public func requestCameraPermission() -> Observable<Void> {
    Observable<Void>.create { observable in
      AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted {
          print("카메라 권한 허용")
        } else {
          print("카메라 권한 거부")
        }
        observable.onNext(())
        observable.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  /// 앨범 권한 요청 메서드
  ///
  /// 온보딩에서 최초 요청시에 사용하게 됩니다.
  ///
  /// 사용예시:
  /// ```swift
  /// button.rx.tap
  ///   .flatMap {
  ///     PermissionHelpler().requestPhotoPermission()
  ///   }
  ///   .subscribe(with: self) { owner, _ in
  ///   }
  ///   .disposed(by: disposBag())
  ///
  public func requestPhotoPermission() -> Observable<Void> {
    Observable<Void>.create { observable in
      PHPhotoLibrary.requestAuthorization(for: .addOnly) { state in
        if state == .authorized {
          print("앨범 권한 허용")
        } else {
          print("앨범 권한 거부")
        }
        observable.onNext(())
        observable.onCompleted()
      }
      return Disposables.create()
    }
  }
  
}
