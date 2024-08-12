//
//  PermissionView.swift
//  OnboardingPresenter
//
//  Created by Jiyeon on 7/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import Utility
import ResourceKit
import DesignSystem

import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 권한 확인을 받기 위한 얼럿 뷰
final class PermissionView {
  private typealias Images = ResourceKitAsset.Images
  private typealias Color = ResourceKitAsset.Colors
  private typealias Font = ResourceKitFontFamily.KR
  
  private let disposeBag = DisposeBag()
  private var window: UIWindow?
  
  // MARK: - UI
  
  private let alertContainer = UIView().then {
    $0.backgroundColor = Color.black.color.withAlphaComponent(0.6)
  }
  private let containerView = UIView().then {
    $0.backgroundColor = Color.white.color
    $0.layer.cornerRadius = 20.adjusted
  }
  private let titleLabel = UILabel().then {
    $0.text = "시작하기 전에"
    $0.textAlignment = .center
    $0.font = Font.H4
    $0.textColor = Color.black.color
  }
  private let contentLabel = UILabel().then {
    $0.text = "원활한 서비스 이용을 위해\n필수 동의가 필요한 내용을 확인해주세요."
    $0.textAlignment = .center
    $0.numberOfLines = 2
    $0.font = Font.B1
    $0.textColor = Color.gray600.color
  }
  private let confirmButton = WalWalButton(type: .active, title: "확인했어요")
  
  private let notiPermissionView = PermissionListView(
    icon: UIImage(systemName: "bell.badge"),
    type: "알림",
    content: "미션 알림 메세지 수신"
  )
  private let cameraPermissionView = PermissionListView(
    icon: UIImage(systemName: "camera"),
    type: "카메라",
    content: "미션 인증 사진 촬영"
  )
  private let photoPermissionView = PermissionListView(
    icon: UIImage(systemName: "photo"),
    type: "사진",
    content: "프로필 이미지 첨부"
  )
  private let permissionView = UIView()
  
  // MARK: - Layout
  
  private func setLayout() {
    alertContainer.addSubview(containerView)
    alertContainer.flex
      .justifyContent(.center)
    
    containerView.flex
      .marginHorizontal(30)
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
            $0.addItem().define {
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
    confirmButton.rx.tapped
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
          PermissionManager.shared.requestNotificationPermission()
            .map { _ in Void() },
          PermissionManager.shared.requestCameraPermission()
            .map { _ in Void() },
          PermissionManager.shared.requestPhotoPermission()
            .map { _ in Void() }
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
  private typealias Color = ResourceKitAsset.Colors
  private typealias Font = ResourceKitFontFamily.KR
  
  private let iconImageView = UIImageView().then {
    $0.tintColor = Color.black.color
    $0.contentMode = .scaleAspectFit
  }
  private let typeLabel = UILabel().then {
    $0.font = Font.H5.M
    $0.textColor = Color.black.color
  }
  private let contentLabel = UILabel().then {
    $0.font = Font.B1
    $0.textColor = Color.gray600.color
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
    self.flex
      .direction(.row)
      .justifyContent(.start)
      .alignItems(.start)
      .define {
        $0.addItem(iconImageView)
          .size(24)
        $0.addItem(typeLabel)
          .marginHorizontal(12)
        $0.addItem(contentLabel)
      }
    self.flex
      .layout(mode: .adjustWidth)
  }
}
