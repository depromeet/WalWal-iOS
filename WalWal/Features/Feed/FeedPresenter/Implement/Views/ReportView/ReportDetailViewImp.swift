//
//  ReportDetailViewImp.swift
//  FeedPresenterImp
//
//  Created by Jiyeon on 10/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//


import UIKit
import FeedPresenter
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxCocoa

public final class ReportDetailViewControllerImp<R: ReportDetailReactor>:
  UIViewController,
  ReportDetailViewController {
  
  private typealias Fonts = ResourceKitFontFamily
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Images = ResourceKitAsset.Images
  
  // MARK: - UI
  
  private let rootContainer = UIView().then {
    $0.backgroundColor = Colors.white.color
    $0.isUserInteractionEnabled = true
  }
  
  private let navBar = UIView()
  private let backButton = UIButton().then {
    $0.setImage(Images.backS.image, for: .normal)
  }
  private let navTitle = CustomLabel(text: "신고", font: Fonts.KR.H5.B).then {
    $0.textColor = Colors.black.color
    $0.textAlignment = .center
  }
  private let navigation = WalWalNavigationBar(leftItems: [.darkBack], leftItemSize: 32, title: "신고", rightItems: [])
  
  
  // MARK: - Properties
  
  public var reportDetailReactor: R
  public var disposeBag = DisposeBag()
  private let sheetDownEvent = PublishRelay<Void>()
  private let endPanGesture = PublishRelay<CGPoint>()
  private let changePanGesture = PublishRelay<(CGPoint, CGPoint)>()
  
  // MARK: - Initalize
  
  public init(reactor: R) {
    self.reportDetailReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.reactor = reportDetailReactor
    configureAttribute()
    configureLayout()
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
  }
  
  public func configureAttribute() {
    view.backgroundColor = .clear
    view.addSubview(rootContainer)
    
    rootContainer.layer.cornerRadius = 30
    rootContainer.layer.maskedCorners = CACornerMask(
      arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner
    )
  }
  
  public func configureLayout() {
    rootContainer.flex
      .define {
        $0.addItem(navigation)
          .marginTop(24.adjustedHeight)
          .width(100%)
      }
  }
}

extension ReportDetailViewControllerImp: View {
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  public func bindAction(reactor: R) {
    
    navigation.leftItems?[0].rx.tapped
      .map { Reactor.Action.backButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    
  }
}

