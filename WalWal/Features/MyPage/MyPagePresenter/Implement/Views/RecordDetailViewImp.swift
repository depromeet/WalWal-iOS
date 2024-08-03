//
//  RecordDetailViewImp.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class RecordDetailViewControllerImp<R: RecordDetailReactor>: UIViewController, RecordDetailViewController {
  
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias FontEN = ResourceKitFontFamily.EN
  private typealias AssetColor = ResourceKitAsset.Colors
  private typealias AssetImage = ResourceKitAsset.Assets
  
  // MARK: - UI
  
  private let containerView = UIView().then {
    $0.backgroundColor = ResourceKitAsset.Colors.gray150.color
  }
  
  private let navigationBar = WalWalNavigationBar(
    leftItems: [.back],
    title: "기록",
    rightItems: []
  ).then {
    $0.backgroundColor = ResourceKitAsset.Colors.white.color
  }
  private let feed = WalWalFeed()
  
  // MARK: - Property
  
  public var disposeBag = DisposeBag()
  public var recordDetailReactor: R
  
  public init(
    reactor: R
  ) {
    self.recordDetailReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setAttribute()
    setLayout()
    bind(reactor: recordDetailReactor)
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    containerView.pin
      .all(view.pin.safeArea)
    containerView.flex
      .layout()
  }
  
  // MARK: - Methods
  
  public func setAttribute() {
    view.backgroundColor = AssetColor.white.color
  }
  
  public func setLayout() {
    view.addSubview(containerView)
    
    containerView.flex
      .direction(.column)
      .define { flex in
        flex.addItem(navigationBar)
        flex.addItem(feed)
          .grow(1)
      }
  }
}

extension RecordDetailViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    reactor.action.onNext(.fetchFeed)
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.feedData }
      .bind(with: self) { owner, model in
        
      }
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    
  }
}
