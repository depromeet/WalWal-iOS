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
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Images = ResourceKitAsset.Assets
  
  // MARK: - UI
  
  private let containerView = UIView().then {
    $0.backgroundColor = Colors.gray150.color
  }
  private let navigationBarView = WalWalNavigationBar(
    leftItems: [],
    title: "프로필 수정",
    rightItems: [.darkClose],
    rightItemSize: 40
  ).then {
    $0.backgroundColor = Colors.white.color
  }
  private var profileEditView: WalWalProfile
  private let nicknameTextfield = WalWalInputBox(
    defaultState: .active,
    placeholder: "",
    rightIcon: .close,
    isAlwaysKeyboard: true
  )
  private let completeButton = WalWalButton(type: .active, title: "완료")
  
  public var disposeBag = DisposeBag()
  public var profileEditReactor: R
  
  // MARK: - Initializer
  
  public init(
    reactor: R,
    nickname: String,
    defaultProfile: String?,
    selectImage: UIImage?,
    raisePet: String
  ) {
    self.profileEditReactor = reactor
    profileEditView = WalWalProfile(
      type: PetType(rawValue: raisePet) ?? .dog,
      defaultImage: defaultProfile,
      userImage: selectImage
    )
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    nicknameTextfield.focusOnTextField()
  }
  
  public override func viewDidLoad() {
    self.reactor = profileEditReactor
    super.viewDidLoad()
    configureAttribute()
    configureLayout()
  }
  
  public override func viewDidLayoutSubviews() {
    view.backgroundColor = Colors.white.color
    super.viewDidLayoutSubviews()
    containerView.pin
      .all(view.pin.safeArea)
    containerView.flex
      .layout()
  }
  
  
  public func configureAttribute() {
    view.backgroundColor = Colors.white.color
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
  
  public func bindAction(reactor: R) {
    let nicknameObservable = nicknameTextfield.rx.text.orEmpty
      .throttle(.milliseconds(350), scheduler: MainScheduler.instance)
    
    let input = Observable.combineLatest(nicknameObservable, profileEditView.curProfileItems)
    
    profileEditView.showPHPicker
      .map { Reactor.Action.checkPhotoPermission }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    navigationBarView.rightItems?.first?.rx.tapped
      .map { Reactor.Action.tapCancelButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.isGrantedPhoto }
      .distinctUntilChanged()
      .bind(with: self, onNext: { owner, isAllowed in
        if isAllowed {
          PHPickerManager.shared.presentPicker(vc: owner)
        } else {
          // 권한 요청 - Alert
        }
      })
      .disposed(by: disposeBag)
    
  }
  
  public func bindEvent() {

  }
}
