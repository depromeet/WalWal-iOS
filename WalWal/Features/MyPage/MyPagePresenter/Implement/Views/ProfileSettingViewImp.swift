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
  public var profileSetting: R
  
  private let logoutAction = PublishRelay<Void>()
  private let withdrawAction = PublishRelay<Void>()
  
  // MARK: - Initializer
  
  public init(
    reactor: R
  ) {
    self.profileSetting = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    self.reactor = profileSetting
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
    
    logoutAction
      .map { Reactor.Action.logout }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    withdrawAction
      .map { Reactor.Action.withdraw }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.settings }
      .bind(to: settingTableView.rx
        .items(ProfileSettingTableViewCell.self)) { row, model, cell in
          cell.configureCell(
            iconImage: model.iconImage,
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
  }
  
  public func bindEvent() {
    settingTableView.rx.modelSelected(ProfileSettingItemModel.self)
      .bind(with: self) { owner, item in
        if item.type == .logout {
          owner.logoutAction.accept(())
        } else if item.type == .withdraw {
          WalWalAlert.shared.show(
            title: "회원 탈퇴",
            bodyMessage: "회원 탈퇴 시, 계정은 삭제되며 기록된 내용은 복구되지 않습니다.",
            cancelTitle: "계속 이용하기",
            okTitle: "회원 탈퇴"
          )
        }
      }
      .disposed(by: disposeBag)
    
    WalWalAlert.shared.resultRelay
      .bind(with: self) { owner, result in
        switch result {
        case .cancel:
          WalWalAlert.shared.closeAlert.accept(())
        case .ok:
          owner.withdrawAction.accept(())
          WalWalAlert.shared.closeAlert.accept(())
        }
      }
      .disposed(by: disposeBag)
  }
}
