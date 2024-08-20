//
//  WalWalAlert.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import PinLayout
import FlexLayout
import Then
import RxSwift
import RxCocoa

public enum AlertResultType {
  case cancel, ok
}

public final class WalWalAlert {
  private typealias Colors = ResourceKitAsset.Colors
  private typealias FontsKR = ResourceKitFontFamily.KR
  
  private let disposeBag = DisposeBag()
  
  /// 얼럿 버튼 탭 시 어떤 버튼이 눌렸는지에 대한 값을 리턴
  ///
  /// - Returns: .cancel 또는 .ok
  public let resultRelay = PublishRelay<AlertResultType>()
  
  /// 얼럿 화면을 닫기 위한 이벤트
  ///
  /// ### 사용 예시
  /// `alertView.closeAlert.accept(())`
  public let closeAlert = PublishRelay<Void>()
  
  // MARK: - UI
  
  private var window: UIWindow?
  private let rootContainer = UIView().then {
    $0.backgroundColor = Colors.black60.color
  }
  private let alertView = UIView().then {
    $0.backgroundColor = Colors.white.color
    $0.layer.cornerRadius = 20
  }
  private let titleLabel = UILabel().then {
    $0.font = FontsKR.H4
    $0.textColor = Colors.black.color
    $0.numberOfLines = 1
    $0.textAlignment = .center
  }
  private let bodyLabel = UILabel().then {
    $0.font = FontsKR.B1
    $0.textColor = Colors.gray600.color
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  private let cancelButton =  WalWalButton(
    type: .custom(
      backgroundColor: Colors.walwalOrange.color,
      titleColor: Colors.white.color,
      font: FontsKR.H6.B, isEnable: true),
    title: ""
  )
  private let okButton = WalWalButton(
    type: .custom(
      backgroundColor: Colors.white.color,
      titleColor: Colors.gray500.color,
      font: FontsKR.H6.B, isEnable: true),
    title: ""
  )
  
  /// - Parameters:
  ///   - title: 상단 얼럿 제목
  ///   - bodyMessage: 얼럿에 대한 내용
  ///   - cancelTitle: 얼럿 내용에 대한 취소 버튼 타이틀
  ///   - okTitle:얼럿 내용에 대한 확인 버튼 타이틀
  public init(
    title: String,
    bodyMessage: String,
    cancelTitle: String,
    okTitle: String
  ) {
    titleLabel.text = title
    bodyLabel.text = bodyMessage
    cancelButton.title = cancelTitle
    okButton.title = okTitle
    bind()
  }
  
  /// 얼럿 뷰를 화면에 보여주기 위한 메서드
  public func show() {
    guard let window = UIWindow.key else { return }
    window.addSubview(rootContainer)
    configureLayout()
  }
  
  private func configureLayout() {
    rootContainer.pin
      .all()
    rootContainer.addSubview(alertView)
    
    
    rootContainer.flex
      .justifyContent(.center)
      .alignItems(.stretch)
    
    alertView.flex
      .marginHorizontal(30)
      .paddingBottom(20)
      .paddingTop(44)
      .define {
        $0.addItem()
          .marginHorizontal(30)
          .define {
            $0.addItem(titleLabel)
            $0.addItem(bodyLabel)
              .marginTop(6)
          }
        $0.addItem()
          .grow(1)
          .marginTop(30)
          .paddingHorizontal(20)
          .define {
            $0.addItem(cancelButton)
              .height(56)
            $0.addItem(okButton)
              .marginTop(8)
              .height(56)
          }
      }
    alertView.flex
      .layout()
    rootContainer.flex
      .layout()
  }
  
  private func bind() {
    Observable.merge(
      cancelButton.rx.tapped
        .map { AlertResultType.cancel},
      okButton.rx.tapped
        .map { AlertResultType.ok}
    )
    .bind(to: resultRelay)
    .disposed(by: disposeBag)
    
    closeAlert
      .bind(with: self) { owner, _ in
        owner.rootContainer.removeFromSuperview()
      }
      .disposed(by: disposeBag)
  }
  
}
