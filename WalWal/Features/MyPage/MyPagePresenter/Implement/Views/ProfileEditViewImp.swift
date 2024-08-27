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
    $0.backgroundColor = Colors.gray100.color
  }
  private let profileContainer = UIView().then {
    $0.backgroundColor = Colors.gray100.color
  }
  private let navigationBarView = WalWalNavigationBar(
    leftItems: [],
    title: "프로필 수정",
    rightItems: [.darkClose],
    rightItemSize: 40
  ).then {
    $0.backgroundColor = Colors.white.color
  }
  private let seperator = UIView().then {
    $0.backgroundColor = Colors.gray150.color
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
  
  // MARK: - Properties
  
  public var disposeBag = DisposeBag()
  public var profileEditReactor: R
  private let maxNicknameLength: Int = 14
  
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
        $0.addItem(seperator)
          .height(1)
          .width(100%)
        $0.addItem(profileContainer)
          .justifyContent(.center)
          .marginTop(60.adjustedHeight)
          .grow(1)
          .define {
            $0.addItem(profileEditView)
              .width(100%)
            $0.addItem(nicknameTextfield)
              .marginHorizontal(20.adjustedWidth)
              .marginTop(45.adjustedHeight)
              .height(72)
          }
        
        $0.addItem(completeButton)
          .marginHorizontal(20.adjustedHeight)
      }
    
  }
  
  private func keyboardLayout() {
    let keyboardTop = view.pin.keyboardArea.height - view.pin.safeArea.bottom
    
    profileContainer.flex.markDirty()
    profileContainer.flex
      .justifyContent(.start)
      .marginTop(60.adjustedHeight)
    nicknameTextfield.flex
      .height(72.adjustedHeight)
    
    rootContainerView.flex.layout()
    
    completeButton.pin
      .height(58)
      .bottom(keyboardTop + 20.adjustedHeight)
    view.layoutIfNeeded()
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
      .asDriver(onErrorJustReturn: false)
      .skip(1)
      .drive(with: self) { owner, isAllowed in
        if isAllowed {
          PHPickerManager.shared.presentPicker(vc: owner)
        } else {
          WalWalAlert.shared.showOkAlert(
            title: "앨범에 대한 접근 권한이 없습니다",
            bodyMessage: "설정 > 왈왈 탭에서 접근을 활성화 할 수 있습니다.",
            okTitle: "확인"
          )
        }
      }
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
    
    reactor.pulse(\.$invalidMessage)
      .asDriver(onErrorJustReturn: "")
      .filter {
        !$0.isEmpty
      }
      .drive(nicknameTextfield.rx.errorMessage)
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
    
    WalWalAlert.shared.resultRelay
      .map { _ in Void() }
      .bind(to: WalWalAlert.shared.closeAlert)
      .disposed(by: disposeBag)
    
    nicknameTextfield.rx.text.orEmpty
      .asDriver()
      .drive(with: self) { owner, text in
        if text.count > owner.maxNicknameLength {
          owner.nicknameTextfield.cutText(
            length: owner.maxNicknameLength,
            text: text
          )
        }
      }
      .disposed(by: disposeBag)
  }
}
