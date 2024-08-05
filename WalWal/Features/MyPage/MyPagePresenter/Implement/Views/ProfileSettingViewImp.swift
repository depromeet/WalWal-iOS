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
  var versionText: String = "1.0.0"
  var isRecentVersion: Bool = true
  private lazy var settings: [Setting] = [
    .init(title: "로그아웃",
          iconImage: AssetImage._16x16NextButton.image,
          subTitle: "",
          rightText: ""),
    .init(title: "버전 정보",
          iconImage: AssetImage._16x16NextButton.image,
          subTitle: versionText,
          rightText: isRecentVersion ? "최신 버전입니다." : "업데이트 필요"),
    .init(title: "회원 탈퇴",
          iconImage: AssetImage._16x16NextButton.image,
          subTitle: "",
          rightText: "")
  ]
  
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
    bind()
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
  
  private func bind() {
    Observable.just(settings)
      .bind(to: self.settingTableView.rx
        .items(cellIdentifier: "ProfileSettingTableViewCell",
               cellType: ProfileSettingTableViewCell.self)) { row, element, cell in
        cell.configureCell(iconImage: element.iconImage,
                           title: element.title,
                           subTitle: element.subTitle,
                           rightText: element.rightText)
      }
               .disposed(by: disposeBag)
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
    
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    
  }
}
