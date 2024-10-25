//
//  ProfileSettingViewImp.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/3/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//


import UIKit
import MyPagePresenter
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa
import SafariServices

public final class ProfileSettingViewControllerImp<R: ProfileSettingReactor>: UIViewController, ProfileSettingViewController {
  
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias FontEN = ResourceKitFontFamily.EN
  private typealias AssetColor = ResourceKitAsset.Colors
  private typealias AssetImage = ResourceKitAsset.Assets
  
  // MARK: - UI
  
  private let containerView = UIView()
  private let navigationBar = WalWalNavigationBar(
    leftItems: [.darkBack],
    leftItemSize: 40,
    title: "설정",
    rightItems: []
  )
  private let settingTableView = UITableView(frame: .zero, style: .plain).then {
    $0.register(ProfileSettingTableViewCell.self)
    $0.backgroundColor = AssetColor.gray100.color
    $0.isScrollEnabled = false
    $0.separatorStyle = .none
    $0.rowHeight = 56
  }
  
  // MARK: - Properties
  
  public var disposeBag = DisposeBag()
  public var profileSettingReactor: R
  
  private let logoutAction = PublishRelay<Void>()
  private let withdrawAction = PublishRelay<Void>()
  private let movePrivacyAction = PublishRelay<Void>()
  private let settingAction = PublishRelay<SettingType>()
  
  // MARK: - Initializer
  
  public init(
    reactor: R
  ) {
    self.profileSettingReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    self.reactor = profileSettingReactor
    super.viewDidLoad()
    setAttribute()
    setLayout()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    containerView.pin
      .all(view.pin.safeArea)
    containerView.flex
      .layout()
  }
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    profileSettingReactor.action.onNext(.isHiddenTabBar(true))
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    profileSettingReactor.action.onNext(.isHiddenTabBar(false))
  }
  
  public func setAttribute() {
    view.backgroundColor = AssetColor.white.color
  }
  
  public func setLayout() {
    view.addSubview(containerView)
    
    containerView.flex
      .direction(.column)
      .define {
        $0.addItem(navigationBar)
        $0.addItem(settingTableView)
          .grow(1)
      }
  }
}

extension ProfileSettingViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    Observable.just(())
      .map { Reactor.Action.viewDidLoad }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    navigationBar.leftItems?[0].rx.tapped
      .map { Reactor.Action.tapBackButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    withdrawAction
      .map { Reactor.Action.settingAction(type: .withdraw) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    movePrivacyAction
      .map { Reactor.Action.movePrivacyTab }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    settingAction
      .map { Reactor.Action.settingAction(type: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.settings }
      .bind(to: settingTableView.rx
        .items(ProfileSettingTableViewCell.self)) { row, model, cell in
          cell.configureCell(
            title: model.title,
            subTitle: model.subTitle,
            rightText: model.rightText
          )
        }
        .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { owner, show in
        ActivityIndicator.shared.showIndicator.accept(show)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$errorMessage)
      .asDriver(onErrorJustReturn: "")
      .compactMap { $0 }
      .drive(with: self) { owner, message in
        WalWalToast.shared.show(type: .error, message: message)
      }
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    settingTableView.rx.modelSelected(ProfileSettingItemModel.self)
      .bind(with: self) { owner, item in
        switch item.type {
        case .withdraw:
          WalWalAlert.shared.rx.showAlert.onNext(AlertEventType.withdraw)
        default: owner.settingAction.accept(item.type)
        }
      }
      .disposed(by: disposeBag)
    
    WalWalAlert.shared.rx.okEvent
      .filter { $0 == .withdraw }
      .map { _ in }
      .bind(to: withdrawAction)
      .disposed(by: disposeBag)
  }
}
