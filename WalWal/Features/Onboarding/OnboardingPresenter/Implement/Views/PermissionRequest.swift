//
//  PermissionRequest.swift
//  OnboardingPresenterImp
//
//  Created by Jiyeon on 7/22/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

import RxSwift

/// 권한 요청 관련 클래스
public final class PermissionRequest {
  
  public func requestNotification() -> Observable<Void> {
    Observable<Void>.create { observable in
      UNUserNotificationCenter.current()
        .requestAuthorization(
          options: [.alert, .sound, .badge]
        ) { isAllow, _ in
          if isAllow {
            print("✅ Push Notification 권한 허용")
            observable.onNext(())
            observable.onCompleted()
          } else {
            print("‼️ Push Notification 권한 거부")
            observable.onNext(())
            observable.onCompleted()
          }
        }
      return Disposables.create()
    }
  }
  
  public func requestCamera() -> Observable<Void> {
    Observable<Void>.create { observable in
      AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted {
          print("✅ 카메라 권한 허용")
          observable.onNext(())
          observable.onCompleted()
        } else {
          print("‼️ 카메라 권한 거부")
          observable.onNext(())
          observable.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  public func requestPhoto() -> Observable<Void> {
      Observable<Void>.create { observable in
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { state in
          if state == .authorized {
            print("✅ 앨범 권한 허용")
            observable.onNext(())
            observable.onCompleted()
          } else {
            print("‼️ 앨범 권한 거부")
            observable.onNext(())
            observable.onCompleted()
          }
        }
        return Disposables.create()
      }
    }
  
}
