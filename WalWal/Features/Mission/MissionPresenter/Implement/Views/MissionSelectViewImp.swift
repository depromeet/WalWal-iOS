//
//  MissionSelectViewController.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 9/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import MissionPresenter
import ResourceKit
import DesignSystem
import Utility

import PinLayout
import FlexLayout
import RxSwift
import RxGesture
import ReactorKit

// 미션 방법 선택하는 modal view
final public class MissionSelectViewControllerImp<R: MissionSelectReactor>: UIViewController, MissionSelectViewController {
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let dimView = UIView().then {
    $0.backgroundColor = Colors.black30.color
  }
  
  private let rootContainer = UIView().then {
    $0.backgroundColor = Colors.white.color
  }
  
  private let titleLabel = CustomLabel(
    text: "오늘의 미션, 어떻게 시작할까요?",
    font: Fonts.KR.H5.B
  ).then {
    $0.textColor = Colors.black.color
    $0.textAlignment = .center
  }
  
  private let cameraButton = WalWalSelectButton(
    titleText: "촬영하기",
    guideText: "지금 순간을 포착해요",
    iconImageType: .camera
  )
  
  private let galleryButton = WalWalSelectButton(
    titleText: "사진첩 열기",
    guideText: "추억 사진을 공유해요",
    iconImageType: .photos)
  
  private let buttonContainerView = UIView()
  
  // MARK: - Properties
  
  private let panGesture = UIPanGestureRecognizer()
  
  public var disposeBag = DisposeBag()
  public var missionSelectReactor: R
  
  // MARK: - Initialize
  
  public init(reactor: R) {
    self.missionSelectReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureAttribute()
    configureLayout()
    self.reactor = missionSelectReactor
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateSheetUp()
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    dimView.pin.all()
    dimView.flex.layout()
    rootContainer.pin.bottom(-rootContainer.frame.height)
  }
  
  // MARK: - Layout
  
  public func configureAttribute() {
    view.backgroundColor = .clear
    view.addSubview(dimView)
    
    rootContainer.layer.cornerRadius = 30
  }
  
  public func configureLayout() {
    dimView.flex
      .define { flex in
        flex.addItem(rootContainer)
          .position(.absolute)
          .bottom(0)
          .width(100%)
      }
    
    rootContainer.flex
      .height(322.adjustedHeight)
      .alignItems(.center)
      .define { flex in
        flex.addItem(titleLabel)
          .marginTop(46.adjusted)
          .marginBottom(24.adjusted)
        flex.addItem(buttonContainerView)
          .marginHorizontal(22.adjusted)
      }
    
    buttonContainerView.flex
      .direction(.row)
      .define { flex in
        flex.addItem(cameraButton)
          .marginRight(11.adjusted)
        flex.addItem(galleryButton)
      }
  }
  
  // MARK: - Animations
  private func animateSheetUp() {
    UIView.animate(withDuration: 0.3) {
      self.dimView.alpha = 1
      self.rootContainer.pin.bottom(0)
      self.rootContainer.flex.layout()
    }
  }
  
  private func animateSheetDown(completion: (() -> Void)? = nil) {
    UIView.animate(withDuration: 0.3, animations: {
      self.dimView.alpha = 0
      self.rootContainer.pin.bottom(-self.rootContainer.frame.height)
      self.rootContainer.flex.layout()
    }, completion: { _ in
      completion?()
    })
  }
  
  private func updateSheetPosition(_ position: CGFloat) {
    if position > 0 {
      rootContainer.pin.bottom(-position)
    } else {
      animateSheetUp()
    }
  }
}

extension MissionSelectViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    rootContainer.rx
      .panGesture()
      .asObservable()
      .subscribe(onNext: { [weak self] gesture in
        guard let self = self else { return }
        let translation = gesture.translation(in: self.rootContainer)
        let velocity = gesture.velocity(in: self.rootContainer)
        
        switch gesture.state {
        case .changed:
          reactor.action.onNext(.didPan(translation: translation, velocity: velocity))
        case .ended:
          reactor.action.onNext(.didEndPan(velocity: velocity))
        default:
          break
        }
      })
      .disposed(by: disposeBag)
    
    cameraButton.rx.tapped
      .map {
        return Reactor.Action.moveToMissionUploadCamera
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    galleryButton.rx.tapped
      .map {
        return Reactor.Action.checkPhotoPermission
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    
    PHPickerManager.shared.selectedPhoto
      .asDriver(onErrorJustReturn: nil)
      .compactMap { $0 }
      .drive(with: self) { owner, image in
        reactor.action.onNext(.moveToMissionGallery(image: image))
      }
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.state.map { $0.sheetPosition }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] position in
        guard let self = self else { return }
        self.updateSheetPosition(position)
      })
      .disposed(by: disposeBag)
    
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
  }
  
  public func bindEvent() {
    
  }
}
