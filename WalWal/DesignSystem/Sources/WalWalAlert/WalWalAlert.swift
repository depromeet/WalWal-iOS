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

public final class WalWalAlert: NSObject {
  fileprivate typealias Colors = ResourceKitAsset.Colors
  fileprivate typealias FontsKR = ResourceKitFontFamily.KR
  
  private var currentEventType: AlertEventType?
  
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
  /// WalWalAlert.shared.rx.event
  ///   .filter { $0 == .updateRequest }
  ///   .map { _ in Reactor.Action.moveUpdate }
  ///   .bind(to: reactor.action)
  ///   .disposed(by: disposeBag)
  /// ```
  /// - Returns: `AlertEventType` 타입의 이벤트 -> 사용자 정의 이벤트
  fileprivate let eventSubject = PublishSubject<AlertEventType>()
  
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
  private let cancelButton = WalWalButton(
    type: .custom(
      backgroundColor: Colors.walwalOrange.color,
      titleColor: Colors.white.color,
      font: FontsKR.H6.B, isEnable: true),
    title: ""
  )
  private let okButton = WalWalButton(
    type: .custom(
      backgroundColor: Colors.walwalOrange.color,
      titleColor: Colors.white.color,
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
    eventType: AlertEventType
  ) {
    titleLabel.text = eventType.contents.title
    bodyLabel.text = eventType.contents.bodyMessage
    cancelButton.title = eventType.contents.cancelTitle
    okButton.title = eventType.contents.okTitle
    
    cancelButton.backgroundColor = eventType.alertColorSet.cancelColorSet.backgroundColor
    cancelButton.titleColor = eventType.alertColorSet.cancelColorSet.textColor
    
    okButton.backgroundColor = eventType.alertColorSet.okColorSet.backgroundColor
    okButton.titleColor = eventType.alertColorSet.okColorSet.textColor
    
    isOneButtonAlert = false
    
    currentEventType = eventType
    
    guard let window = UIWindow.key else { return }
    window.addSubview(rootContainer)
    configureLayout()
    cancelButton.isHidden = false
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
    eventType: AlertEventType
  ) {
    titleLabel.text = eventType.contents.title
    bodyLabel.text = eventType.contents.bodyMessage
    okButton.title = eventType.contents.okTitle
    
    cancelButton.backgroundColor = eventType.alertColorSet.cancelColorSet.backgroundColor
    cancelButton.titleColor = eventType.alertColorSet.cancelColorSet.textColor
    
    okButton.backgroundColor = eventType.alertColorSet.okColorSet.backgroundColor
    okButton.titleColor = eventType.alertColorSet.okColorSet.textColor
    
    isOneButtonAlert = true
    
    currentEventType = eventType
    
    guard let window = UIWindow.key else { return }
    window.addSubview(rootContainer)
    configureLayout()
    cancelButton.isHidden = true
  }
  
  private func configureLayout() {
    
    initLayout()
    closeButtonMargin = isOneButtonAlert ? 20 : 8
    cancelButton.flex.isIncludedInLayout = !isOneButtonAlert
    
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
        $0.addItem(okButton)
          .height(56.adjustedHeight)
          .marginTop(closeButtonMargin)
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
    /// cancel버튼은 이벤트 처리 X
    cancelButton.rx.tapped
      .bind(with: self) { owner, _ in
        owner.rootContainer.removeFromSuperview()
      }
      .disposed(by: disposeBag)
    
    /// 이벤트 처리는 무조건 okButton (버튼이 단일이라면, cancel의 역할을 할 수도 있음)
    okButton.rx.tapped
      .bind(with: self) { owner, _ in
        if let eventType = owner.currentEventType {
          owner.eventSubject.onNext(eventType)
        }
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
  var showAlert: Binder<AlertEventType> {
    return Binder(self.base) { owner, event in
      event.contents.cancelTitle == nil ? owner.showOkAlert(eventType: event) : owner.show(eventType: event)
    }
  }
  
  var okEvent: Observable<AlertEventType> {
    return base.eventSubject.asObservable()
  }
}

public enum AlertEventType {
  /// 앱 업데이트 요청 이벤트
  case updateRequest
  /// 카메라 접근 권한 허용 이벤트
  case grantedCameraAccess
  /// 포토 라이브러리 접근 권한 허용 이벤트
  case grantedPhotoLibraryAccess
  /// 신고 이벤트
  case report
  /// 미션 기록 삭제 이벤트
  case deleteMissionRecord
  /// 회원 탈퇴 이벤트
  case withdraw
  
  var contents: (title: String, bodyMessage: String, cancelTitle: String?, okTitle: String, tintColor: AlertColorSet) {
    switch self {
    case .updateRequest:
      return (
        title: "신규 기능 업데이트",
        bodyMessage: "왈왈에서 더 재밌게 소통할 수 있도록\n신규 기능을 업데이트 해보세요!",
        cancelTitle: nil,
        okTitle: "업데이트",
        tintColor: self.alertColorSet
      )
    case .grantedCameraAccess:
      return (
        title: "카메라에 대한 접근 권한이 없습니다",
        bodyMessage: "설정 > 왈왈 탭에서 접근을 활성화 할 수 있습니다.",
        cancelTitle: nil,
        okTitle: "확인",
        tintColor: self.alertColorSet
      )
    case .grantedPhotoLibraryAccess:
      return (
        title: "앨범에 대한 접근 권한이 없습니다",
        bodyMessage: "설정 > 왈왈 탭에서 접근을 활성화 할 수 있습니다.",
        cancelTitle: nil,
        okTitle: "확인",
        tintColor: self.alertColorSet
      )
    case .report:
      return (
        title: "소중한 정보 고마워요!",
        bodyMessage: "더 귀여운 왈왈을 위해 열심히 노력할게요?",
        cancelTitle: nil,
        okTitle: "완료",
        tintColor: self.alertColorSet
        )
    case .deleteMissionRecord:
      return (
        title: "기록을 삭제하시겠어요?",
        bodyMessage: "지금 돌아가면 입력하신 내용이 모두\n삭제됩니다.",
        cancelTitle: "계속 작성하기",
        okTitle: "삭제하기",
        tintColor: self.alertColorSet
        )
    case .withdraw:
      return (
        title: "회원 탈퇴",
        bodyMessage: "회원 탈퇴 시, 계정은 삭제되며 기록된 내용은\n복구되지 않습니다.",
        cancelTitle: "계속 이용하기",
        okTitle: "회원 탈퇴",
        tintColor: self.alertColorSet
        )
    }
  }
  
  var alertColorSet: AlertColorSet {
    let orange = ResourceKitAsset.Colors.walwalOrange.color
    let white = ResourceKitAsset.Colors.white.color
    
    let black = ResourceKitAsset.Colors.black.color
    let gray = ResourceKitAsset.Colors.gray500.color
    
    switch self {
    case .updateRequest:
      return AlertColorSet(
        cancelColorSet: (backgroundColor: nil, textColor: nil),
        okColorSet: (backgroundColor: orange, textColor: white)
      )
    case .grantedCameraAccess:
      return AlertColorSet(
        cancelColorSet: (backgroundColor: nil, textColor: nil),
        okColorSet: (backgroundColor: orange, textColor: white)
      )
    case .grantedPhotoLibraryAccess:
      return AlertColorSet(
        cancelColorSet: (backgroundColor: nil, textColor: nil),
        okColorSet: (backgroundColor: orange, textColor: white)
      )
    case .report:
      return AlertColorSet(
        cancelColorSet: (backgroundColor: nil, textColor: nil),
        okColorSet: (backgroundColor: black, textColor: white)
      )
    case .deleteMissionRecord:
      return AlertColorSet(
        cancelColorSet: (backgroundColor: orange, textColor: white),
        okColorSet: (backgroundColor: white, textColor: gray)
      )
    case .withdraw:
      return AlertColorSet(
        cancelColorSet: (backgroundColor: orange, textColor: white),
        okColorSet: (backgroundColor: white, textColor: gray)
      )
    }
  }
  
  struct AlertColorSet {
    var cancelColorSet: (backgroundColor: UIColor?, textColor: UIColor?)
    var okColorSet: (backgroundColor: UIColor?, textColor: UIColor?)
  }
}
