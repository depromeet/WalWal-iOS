//
//  TermsViewControllerImp.swift
//  MyPagePresenterImp
//
//  Created by Jiyeon on 8/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import MyPagePresenter
import ResourceKit
import DesignSystem

import FlexLayout
import PinLayout
import Then
import ReactorKit
import RxCocoa

public final class TermsViewControllerImp<R: TermsReactor>: UIViewController, TermsViewController {
  
  private typealias FontKR = ResourceKitFontFamily.KR
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let navigationBar: WalWalNavigationBar
  private let textView = UITextView().then {
    $0.isEditable = false
    $0.isScrollEnabled = true
    $0.font = FontKR.B2
    $0.showsVerticalScrollIndicator = false
    $0.isSelectable = false
  }
  
  // MARK: - Properties
  
  public var termsReactor: R
  public var disposeBag = DisposeBag()
  private let termType: TermsType
  
  // MARK: - Initialize
  
  public init(
    reactor: R,
    termType: TermsType
  ) {
    self.termsReactor = reactor
    self.termType = termType
    navigationBar = WalWalNavigationBar(
      leftItems: [],
      title: termType.title,
      rightItems: [.darkClose],
      rightItemSize: 40
    )
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.reactor = termsReactor
    view.backgroundColor = ResourceKitAsset.Colors.white.color
    textView.text = LegalText.serviceTerms
    setAttribute()
    setLayout()
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin
      .all(view.pin.safeArea)
    
    rootContainer.flex
      .layout()
  }
  
  public func setAttribute() {
    view.addSubview(rootContainer)
    [navigationBar, textView].forEach {
      rootContainer.addSubview($0)
    }
  }
  
  public func setLayout() {
    rootContainer.flex
      .justifyContent(.start)
    
    navigationBar.flex
      .width(100%)
    
    textView.flex
      .grow(1)
      .marginHorizontal(20)
  }
  
}

// MARK: - Binding

extension TermsViewControllerImp: View {
  
  public func bind(reactor: R) {
    navigationBar.rightItems?.first?.rx.tapped
      .map { Reactor.Action.close }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

// MARK: - TermsType

fileprivate extension TermsType {
  var title: String {
    switch self {
    case .service:
      return "서비스 이용약관"
    case .privacy:
      return "개인정보처리방침"
    }
  }
  var text: String {
    switch self {
    case .service:
      return LegalText.serviceTerms
    case .privacy:
      return LegalText.privacyPolicy
    }
  }
}
