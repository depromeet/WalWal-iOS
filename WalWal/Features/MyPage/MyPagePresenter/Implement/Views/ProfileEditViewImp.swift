//
//  ProfileEditViewImp.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import MyPagePresenter
import DesignSystem
import ResourceKit
import Utility

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class ProfileEditViewControllerImp<R: ProfileEditReactor>: UIViewController, ProfileEditViewController {
  
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias FontEN = ResourceKitFontFamily.EN
  private typealias AssetColor = ResourceKitAsset.Colors
  private typealias AssetImage = ResourceKitAsset.Assets
  
  // MARK: - UI
  
  private let containerView = UIView().then {
    $0.backgroundColor = AssetColor.gray150.color
  }
  private let navigationBarView = WalWalNavigationBar(
    leftItems: [],
    title: "프로필 수정",
    rightItems: [.darkClose],
    rightItemSize: 40
  ).then {
    $0.backgroundColor = AssetColor.white.color
  }
  private let profileEditView = WalWalProfile(type: .dog)
  private let nicknameTextfield = WalWalInputBox(
    defaultState: .active,
    placeholder: "",
    rightIcon: .close
  )
  private let completeButton = WalWalButton(type: .active, title: "완료")
  
  public var disposeBag = DisposeBag()
  public var profileEditReactor: R
  
  // MARK: - Initializer
  
  public init(
    reactor: R
  ) {
    self.profileEditReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    self.reactor = profileEditReactor
    super.viewDidLoad()
    configureAttribute()
    configureLayout()
    nicknameTextfield.becomeFirstResponder()
  }
  
  public override func viewDidLayoutSubviews() {
    view.backgroundColor = AssetColor.white.color
    super.viewDidLayoutSubviews()
    containerView.pin
      .all(view.pin.safeArea)
    containerView.flex
      .layout()
  }
  
  
  public func configureAttribute() {
    view.backgroundColor = AssetColor.white.color
  }
  
  public func configureLayout() {
    view.addSubview(containerView)
    
    containerView.flex
      .direction(.column)
      .define {
        $0.addItem(navigationBarView)
        $0.addItem(profileEditView)
          .marginTop(55.adjusted)
          .marginHorizontal(0)
        $0.addItem(nicknameTextfield)
          .marginTop(40.adjusted)
          .marginHorizontal(20.adjusted)
          .marginBottom(5.adjusted)
        $0.addItem(completeButton)
          .marginHorizontal(20.adjusted)
      }
  }
}

extension ProfileEditViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {  }
  
  public func bindState(reactor: R) {  }
  
  public func bindEvent() {
    navigationBarView.rightItems?.first?.rx.tapped
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
    profileEditView.showPHPicker
      .bind(with: self) { owner, _ in
        PHPickerManager.shared.presentPicker(vc: owner)
      }
      .disposed(by: disposeBag)
  }
}
