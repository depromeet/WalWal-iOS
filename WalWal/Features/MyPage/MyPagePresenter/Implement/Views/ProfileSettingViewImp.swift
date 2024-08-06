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
    leftItems: [.back],
    title: "설정",
    rightItems: []
  )
  private let settingTableView = UITableView(frame: .zero, style: .plain).then {
    $0.register(ProfileSettingTableViewCell.self, forCellReuseIdentifier: "ProfileSettingTableViewCell")
    $0.backgroundColor = AssetColor.gray100.color
    $0.isScrollEnabled = false
    $0.separatorStyle = .none
    $0.rowHeight = 56
  }
  
  public var disposeBag = DisposeBag()
  public var __reactor: R
  
  // MARK: - Initializer
  
  public init(
    reactor: R
  ) {
    self.__reactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    self.reactor = __reactor
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
    
    
    settingTableView.rx
      .itemSelected
      .map { Reactor.Action.didSelectItem(at: $0) }
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
  }
  
  public func bindEvent() {
    
  }
}
