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

public enum AlertEventType {
  case updateRequest /// 앱 업데이트 요청 이벤트
}

public final class WalWalAlert: NSObject {
  private typealias Colors = ResourceKitAsset.Colors
  private typealias FontsKR = ResourceKitFontFamily.KR
  
  private let disposeBag = DisposeBag()
  public static let shared = WalWalAlert()
  private override init() {
    super.init()
    bind()
  }
  
  /// 얼럿 버튼 탭 시 어떤 버튼이 눌렸는지에 대한 값을 리턴
  /// 얼럿의 이벤트 기반의 동작
  ///
  /// ### 사용 예시
  /// ```swift
  /// WalWalAlert.shared.resultRelay
  ///  .filter { $0 == `이벤트 타입` }
  ///  .bind(with: self) { owner, result in
  ///    print("이벤트 타입: \(result.rawValue)")
  ///  }
  /// ```
  /// - Returns: `AlertEventType` 타입의 이벤트 -> 사용자 정의 이벤트
  fileprivate let eventRelay = PublishRelay<AlertEventType>()
  
  private var isOneButtonAlert: Bool = false
  private var closeButtonMargin: CGFloat = 8
  
  // MARK: - UI
  
  private var window: UIWindow?
  private let rootContainer = UIView().then {
    $0.backgroundColor = Colors.black60.color
  }
  private let alertView = UIView().then {
    $0.backgroundColor = Colors.white.color
    $0.layer.cornerRadius = 20
  }
  private let titleLabel = CustomLabel(font: FontsKR.H4).then {
    $0.textColor = Colors.black.color
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  private let bodyLabelContainer = UIView()
  private let bodyLabel = CustomLabel(font: FontsKR.B1).then {
    $0.font = FontsKR.B1
    $0.textColor = Colors.gray600.color
    $0.numberOfLines = 0
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
  
  /// 얼럿 뷰를 보여주기 위한 메서드
  /// ### 사용예시
  /// ```swift
  ///   WalWalAlert.shared.show(
  ///     title: "회원 탈퇴",
  ///     bodyMessage: "회원 탈퇴 시, 계정은 삭제되며 기록된 내용은 복구되지 않습니다.",
  ///     cancelTitle: "계속 이용하기",
  ///     okTitle: "회원 탈퇴"
  ///   )
  /// ```
  /// - Parameters:
  ///   - title: 상단 얼럿 제목
  ///   - bodyMessage: 얼럿에 대한 내용
  ///   - cancelTitle: 얼럿 내용에 대한 취소 버튼 타이틀
  ///   - okTitle:얼럿 내용에 대한 확인 버튼 타이틀
  fileprivate func show(
    title: String,
    bodyMessage: String,
    cancelTitle: String,
    okTitle: String,
    tintColor: UIColor? = nil
  ) {
    titleLabel.text = title
    bodyLabel.text = bodyMessage
    cancelButton.title = cancelTitle
    okButton.title = okTitle
    cancelButton.backgroundColor = tintColor ?? Colors.walwalOrange.color
    isOneButtonAlert = false
    
    guard let window = UIWindow.key else { return }
    window.addSubview(rootContainer)
    configureLayout()
    okButton.isHidden = false
  }
  
  /// 얼럿 뷰를 보여주기 위한 메서드
  /// ### 사용예시
  /// ```swift
  ///   WalWalAlert.shared.showOkAlert(
  ///     title: "앨범에 대한 접근 권한이 없습니다.",
  ///     bodyMessage: "설정 > 왈왈 탭에서 접근을 활성화 할 수 있습니다.",
  ///     okTitle: "확인"
  ///   )
  /// ```
  /// - Parameters:
  ///   - title: 상단 얼럿 제목
  ///   - bodyMessage: 얼럿에 대한 내용
  ///   - okTitle:얼럿 내용에 대한 확인 버튼 타이틀
  ///   - tintColor: 하이라이팅 컬러 (default: WalWalOrange)
  fileprivate func showOkAlert(
    title: String,
    bodyMessage: String,
    okTitle: String,
    tintColor: UIColor? = nil
  ) {
    titleLabel.text = title
    bodyLabel.text = bodyMessage
    cancelButton.title = okTitle
    isOneButtonAlert = true
    cancelButton.backgroundColor = tintColor ?? Colors.walwalOrange.color
    
    guard let window = UIWindow.key else { return }
    window.addSubview(rootContainer)
    configureLayout()
    okButton.isHidden = true
  }
  
  private func configureLayout() {
    
    initLayout()
    closeButtonMargin = isOneButtonAlert ? 20 : 8
    okButton.flex.isIncludedInLayout = !isOneButtonAlert
    
    rootContainer.addSubview(alertView)
    
    rootContainer.pin
      .all()
    
    alertView.flex
      .width(315.adjustedWidth)
      .define {
        $0.addItem(titleLabel)
          .height(24.adjustedHeight)
          .marginTop(43.adjustedHeight)
          .marginHorizontal(30.adjustedWidth)
        $0.addItem(bodyLabelContainer)
          .grow(1)
          .marginTop(6.adjustedHeight)
          .marginHorizontal(30.adjustedWidth)
        $0.addItem(cancelButton)
          .height(56.adjustedHeight)
          .marginTop(30.adjustedHeight)
          .marginHorizontal(20.adjustedWidth)
          .marginBottom(closeButtonMargin)
        $0.addItem(okButton)
          .height(56.adjustedHeight)
          .marginBottom(20.adjustedWidth)
          .marginHorizontal(20.adjustedWidth)
      }
    
    bodyLabelContainer.flex
      .minHeight(34.adjustedHeight)
      .justifyContent(.end)
      .define {
        $0.addItem()
          .grow(1)
        $0.addItem(bodyLabel)
      }
    
    rootContainer.flex
      .justifyContent(.center)
    rootContainer.flex
      .layout()
    alertView.pin
      .center()

  }
  
  private func bind() {
    cancelButton.rx.tapped
      .bind(with: self) { owner, _ in
        owner.rootContainer.removeFromSuperview()
      }
      .disposed(by: disposeBag)
    
    okButton.rx.tapped
      .bind(with: self) { owner, _ in
        owner.rootContainer.removeFromSuperview()
      }
      .disposed(by: disposeBag)
  }
  
  private func initLayout() {
    bodyLabelContainer.subviews.forEach { $0.removeFromSuperview() }
    alertView.subviews.forEach { $0.removeFromSuperview() }
    rootContainer.subviews.forEach { $0.removeFromSuperview() }
  }
}

public extension Reactive where Base: WalWalAlert {
  var showAlert: Binder<(String, String, String, String?)> {
    return Binder(self.base) { owner, value in
      owner.show(title: value.0, bodyMessage: value.1, cancelTitle: value.2, okTitle: value.3)
    }
  }
  
  var showOkAlert: Binder<(String, String, String)> {
    return Binder(self.base) { owner, value in
      owner.showOkAlert(title: value.0, bodyMessage: value.1, okTitle: value.2)
    }
  }
  
  var event: ControlEvent<AlertEventType> {
    return ControlEvent(events: base.eventRelay.asObservable())
  }
}
