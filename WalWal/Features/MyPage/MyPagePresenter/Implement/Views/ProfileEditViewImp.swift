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
  
  private let rootContainerView = UIView().then {
    $0.backgroundColor = Colors.gray150.color
  }
  private let profileContainer = UIView().then {
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
  ).then {
    $0.focusOnTextField()
  }
  private let completeButton = WalWalButton(type: .disabled, title: "완료")
  
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
    nicknameTextfield.rx.text.onNext(nickname)
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
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let _ = view.pin.keyboardArea.height
    view.backgroundColor = Colors.white.color
    
    rootContainerView.pin
      .all(view.pin.safeArea)
    rootContainerView.flex
      .layout()
    
  }
  
  public func configureAttribute() {
    view.backgroundColor = Colors.white.color
    view.addSubview(rootContainerView)
    [navigationBarView, profileContainer, completeButton].forEach {
      rootContainerView.addSubview($0)
    }
  }
  
  public func configureLayout() {
    
    rootContainerView.flex
      .justifyContent(.spaceBetween)
      .define {
        $0.addItem(navigationBarView)
          .width(100%)
        $0.addItem(profileContainer)
          .justifyContent(.center)
          .marginTop(50.adjustedHeight)
          .marginBottom(17.adjustedHeight)
          .grow(1)
          .define {
            $0.addItem(profileEditView)
              .width(100%)
            $0.addItem(nicknameTextfield)
              .marginHorizontal(20.adjustedWidth)
          }
        
        $0.addItem(completeButton)
          .marginHorizontal(20.adjusted)
      }
    
  }
  
  private func keyboardLayout() {
    let keyboardTop = view.pin.keyboardArea.height - view.pin.safeArea.bottom
    completeButton.flex
      .marginBottom(keyboardTop+20.adjustedHeight)
    profileContainer.flex
      .justifyContent(.spaceBetween)
      .marginTop(60.adjusted)
      .marginBottom(17.adjustedHeight)
    
    nicknameTextfield.flex
      .marginTop(45.adjusted)
    
    rootContainerView.flex.layout()
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
    let inputValue =  Observable.combineLatest(nicknameTextfield.rx.text.orEmpty, profileEditView.curProfileItems)
    inputValue
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .map {
        Reactor.Action.checkCondition(nickname: $0, profile: $1)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    profileEditView.showPHPicker
      .map { Reactor.Action.checkPhotoPermission }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    completeButton.rx.tapped
      .withLatestFrom(inputValue) {
        Reactor.Action.editProfile(nickname: $1.0, profile: $1.1)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    navigationBarView.rightItems?.first?.rx.tapped
      .map { Reactor.Action.tapCancelButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.pulse(\.$isGrantedPhoto)
      .bind(with: self, onNext: { owner, isAllowed in
        if isAllowed {
          PHPickerManager.shared.presentPicker(vc: owner)
        } else {
          // TODO: - alert 띄우기
        }
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { return $0.buttonEnable ? .active : .disabled }
      .bind(to: completeButton.rx.buttonType)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.showIndicator }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { owner, show in
        ActivityIndicator.shared.showIndicator.accept(show)
      }
      .disposed(by: disposeBag)
    
  }
  
  public func bindEvent() {
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .bind(with: self) { owner, _ in
        owner.keyboardLayout()
      }
      .disposed(by: disposeBag)
    
    PHPickerManager.shared.selectedPhoto
      .asDriver(onErrorJustReturn: nil)
      .compactMap { $0 }
      .drive(with: self) { owner, image in
        owner.profileEditView.selectedImageData.accept(image)
      }
      .disposed(by: disposeBag)
  }
}
