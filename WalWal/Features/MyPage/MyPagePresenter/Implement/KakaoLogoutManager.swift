//
//  KakaoLogoutManager.swift
//  MyPagePresenter
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import RxSwift
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon


final class KakaoLogoutManager {
  
  /// 카카오 로그아웃 요청
  ///
  /// 사용 예시
  /// ``` swift
  /// logoutButton.rx.tap
  ///   .flatMap {
  ///     KakaoLoginManager().kakaoLogout()
  ///   }
  ///   .bind { _ in
  ///     print("logout success")
  ///   } onError {
  ///     print(error.localizedDescription)
  ///   }
  ///   .disposed(by: disposeBag)
  func kakaoLogout() -> Single<Void> {
      return Single<Void>.create { single in
          UserApi.shared.logout { error in
              if let error = error {
                  print(error)
                  single(.failure(error))
              } else {
                  print("logout() success.")
                  single(.success(()))
              }
          }
          return Disposables.create()
      }
  }
  
  /// 카카오 로그인 연결 끊기
  ///
  /// 사용 예시
  /// ``` swift
  /// unlinkButton.rx.tap
  ///   .flatMap {
  ///     KakaoLoginManager().kakaoUnlink()
  ///   }
  ///   .bind { _ in
  ///     print("unlink success")
  ///   } onError {
  ///     print(error.localizedDescription)
  ///   }
  ///   .disposed(by: disposeBag)
  func kakaoUnlink() -> Single<Void> {
    return Single<Void>.create { single in
      UserApi.shared.unlink { error in
        if let error = error {
          single(.failure(error))
        }
        else {
          single(.success(()))
        }
      }
      return Disposables.create()
    }
  }
}
