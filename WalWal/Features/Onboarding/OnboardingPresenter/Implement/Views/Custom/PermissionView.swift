//
//  PermissionView.swift
//  OnboardingPresenterImp
//
//  Created by Jiyeon on 7/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import Utility

import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 권한 확인을 받기 위한 얼럿 뷰 입니다.
final class PermissionView {
  private let disposeBag = DisposeBag()
  private var window: UIWindow?
  private let permissionRequest = PermissionRequest()
  // MARK: - UI
  
  private let alertContainer = UIView().then {
    $0.backgroundColor =  UIColor.black.withAlphaComponent(0.6)
  }
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 20
  }
  private let titleLabel = UILabel().then {
    $0.text = "시작하기 전에"
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 20, weight: .semibold)
    $0.textColor = .black
  }
  private let contentLabel = UILabel().then {
    $0.text = "원활한 서비스 이용을 위해\n필수 동의가 필요한 내용을 확인해주세요."
    $0.textAlignment = .center
    $0.numberOfLines = 2
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = .gray
  }
  private let confirmButton = CompleteButton(title: "확인했어요", isEnable: true)
  
  private let notiPermissionView = PermissionListView(icon: UIImage(systemName: "bell.badge"), type: "알림", content: "미션 알림 메세지 수신")
  private let cameraPermissionView = PermissionListView(icon: UIImage(systemName: "camera"), type: "카메라", content: "미션 인증 사진 촬영")
  private let photoPermissionView = PermissionListView(icon: UIImage(systemName: "photo"), type: "사진", content: "프로필 이미지 첨부")
  private let permissionView = UIView()
  
  init() {
    
  }
  
  // MARK: - Layout
  
  private func setLayout() {
    alertContainer.addSubview(containerView)
    alertContainer.flex
      .justifyContent(.center)
      .alignItems(.stretch)
    
    containerView.flex
      .marginHorizontal(30)
      .alignItems(.stretch)
      .define {
        $0.addItem(titleLabel)
          .marginTop(45)
        $0.addItem(contentLabel)
          .marginTop(8)
        $0.addItem()
          .direction(.row)
          .justifyContent(.center)
          .marginTop(40)
          .marginBottom(46)
          .define {
            $0.addItem()
              .define {
                $0.addItem(notiPermissionView)
                $0.addItem(cameraPermissionView)
                  .marginVertical(25)
                $0.addItem(photoPermissionView)
              }
          }
        $0.addItem(confirmButton)
          .marginHorizontal(20)
          .marginBottom(20)
          .height(56)
      }
    
    containerView.flex.layout(mode: .adjustHeight)
    alertContainer.pin.all()
    alertContainer.flex.layout()
  }
  
  /// window 위에 얼럿을 띄우기 위한 메서드
  ///
  /// 사용예시
  /// ```swift
  /// let permissionView = PermissionView()
  /// permissionView.showAlert()
  /// ```
  func showAlert() {
    guard let window = UIWindow.key else { return }
    self.window = window
    window.addSubview(alertContainer)
    self.setLayout()
    bind()
  }
  
  private func bind() {
    let requestPermission = PublishSubject<Void>()
    confirmButton.rx.tap
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.alertContainer.removeFromSuperview()
        requestPermission.onNext(())
      }
      .disposed(by: disposeBag)
    
    requestPermission
      .withUnretained(self)
      .concatMap{ owner, _ in
        Observable<Void>.concat(
          owner.permissionRequest.requestNotification(),
          owner.permissionRequest.requestCamera(),
          owner.permissionRequest.requestPhoto()
        )
      }
      .asDriver(onErrorJustReturn: ())
      .drive(with: self, onNext: { owner, _ in
        
      })
      .disposed(by: disposeBag)
  }
  
}

/// 동의를 받아야하는 권한 리스트 뷰를 재사용하기 위한 View
fileprivate final class PermissionListView: UIView {
  private let iconImageView = UIImageView().then {
    $0.tintColor = .black
    $0.contentMode = .scaleAspectFit
  }
  private let typeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 18, weight: .medium)
    $0.textColor = .black
  }
  private let contentLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .regular)
    $0.textColor = .darkGray
  }
  
  /// - Parameters:
  ///   - icon: 권한 아이콘
  ///   - type: 동의 받을 권한의 종류
  ///   - content: 권한 내용
  init(icon: UIImage?, type: String, content: String) {
    super.init(frame: .zero)
    iconImageView.image = icon
    typeLabel.text = type
    contentLabel.text = content
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setLayout() {
    self.flex.direction(.row).justifyContent(.start).alignItems(.start).define {
      $0.addItem(iconImageView).size(24)
      $0.addItem(typeLabel).marginHorizontal(12)
      $0.addItem(contentLabel)
    }
    self.flex.layout(mode: .adjustWidth)
  }
  
}
