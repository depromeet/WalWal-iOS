//
//  WalWalOKAlert.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import PinLayout
import FlexLayout
import Then
import RxSwift
import RxCocoa


/// 확인 버튼만 있는 얼럿 뷰
public final class WalWalOKAlert {
  private typealias Colors = ResourceKitAsset.Colors
  private typealias FontsKR = ResourceKitFontFamily.KR
  
  public static let shared = WalWalOKAlert()
  private init() { 
    bind()
  }
  
  // MARK: - Properties
  
  /// OK 버튼 눌렸음에 대한 이벤트 전달
  /// ### 사용 예시
  /// ```swift
  /// WalWalOKAlert.shared.okButtonTapped
  ///  .bind(with: self) { owner, _ in
  ///   // 이벤트 처리
  ///    WalWalOKAlert.shared.closeAlert.accept(()) // 얼럿 닫기
  ///  }
  ///  .disposed(by: disposeBag)
  /// ```
  public let okButtonTapped = PublishRelay<Void>()
  
  /// 얼럿 뷰를 닫기 위한 이벤트
  ///
  /// ### 사용 예시
  /// ```swift
  /// // 버튼 눌렸을 때 바로 화면 닫기
  /// WalWalOKAlert.shared.okButtonTapped
  ///   .bind(to: WalWalOKAlert.shared.closeAlert)
  ///   .disposed(by: disposeBag)
  /// ```
  public let closeAlert = PublishRelay<Void>()
  private let disposeBag = DisposeBag()
  
  // MARK: - UI
  
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
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  private let bodyLabel = UILabel().then {
    $0.font = FontsKR.B1
    $0.textColor = Colors.gray600.color
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  private let okButton = WalWalButton(
    type: .custom(
      backgroundColor: Colors.walwalOrange.color,
      titleColor: Colors.white.color,
      font: FontsKR.H6.B, isEnable: true),
    title: ""
  )
  
  
  /// 얼럿 뷰 보여주기 위한 메서드
  /// ### 사용예시
  /// ```swift
  ///   WalWalOKAlert.shared.show(
  ///     title: "앨범에 대한 접근 권한이 없습니다.",
  ///     bodyMessage: "설정 > 왈왈 탭에서 접근을 활성화 할 수 있습니다.",
  ///     okTitle: "확인"
  ///   )
  /// ```
  /// - Parameters:
  ///   - title: 상단 얼럿 제목
  ///   - bodyMessage: 얼럿에 대한 내용
  ///   - okTitle:얼럿 내용에 대한 확인 버튼 타이틀
  public func show(
    title: String,
    bodyMessage: String,
    okTitle: String
  ) {
    titleLabel.text = title
    bodyLabel.text = bodyMessage
    okButton.title = okTitle
    
    guard let window = UIWindow.key else { return }
    window.addSubview(rootContainer)
    configureLayout()
  }
  
  private func configureLayout() {
    rootContainer.addSubview(alertView)
    rootContainer.pin
      .all()
    
    alertView.flex
      .width(315.adjusted)
      .define {
        $0.addItem(titleLabel)
          .marginTop(44)
          .marginHorizontal(30)
        $0.addItem(bodyLabel)
          .marginTop(6)
          .marginHorizontal(30)
        $0.addItem(okButton)
          .marginTop(30)
          .marginBottom(20)
          .marginHorizontal(20)
        
      }
    rootContainer.flex
      .justifyContent(.center)
    rootContainer.flex
      .layout()
    alertView.pin
      .center()

  }
  
  private func bind() {
    okButton.rx.tapped
      .bind(to: okButtonTapped)
      .disposed(by: disposeBag)
    
    closeAlert
      .bind(with: self) { owner, _ in
        owner.rootContainer.removeFromSuperview()
      }
      .disposed(by: disposeBag)
  }
  
}
