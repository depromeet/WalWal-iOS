//
//  CameraShootDuringTheMissionViewImp.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import UIKit
import MissionUploadPresenter
import ResourceKit
import DesignSystem
import Utility

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class CameraShootDuringTheMissionViewControllerImp<R: CameraShootDuringTheMissionReactor>:
  UIViewController,
  CameraShootDuringTheMissionViewController {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Assets = ResourceKitAsset.Assets
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  public var disposeBag = DisposeBag()
  public var cameraShootingDuringTheMissionReactor: R
  
  private var missionTitle: String
  
  private let rootFlexContainer = UIView()
  
  private let navigationContainer = UIView()
  private let closeButton = WalWalTouchArea(
    image: Images.closeL.image,
    size: 40
  )
  
  private let cameraContainer = UIView()
  private let cameraPreviewView = UIView().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 20
  }
  private let previewView = UIView()
  
  private let noticeContainer = UIView()
  private lazy var noticeLabelChip = WalWalChip(
    text: missionTitle,
    opacity: 0.9,
    image: Images.flagS.image,
    style: .semiFilled
  )
  
  private let controlContainer = UIView()
  private var captureButton = WalWalTouchArea(
    image: Assets.cameraCapture.image,
    size: 74
  )
  private var switchCameraButton = WalWalTouchArea(
    image: Assets.cameraPosSwipe.image,
    size: 48
  )
  
  
  private let cameraManager: CameraManager
  
  public init(
    missionTitle: String,
    reactor: R
  ) {
    self.cameraShootingDuringTheMissionReactor = reactor
    self.cameraManager = CameraManager()
    self.missionTitle = missionTitle
    
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
    configurePinchGesture()
    self.reactor = self.cameraShootingDuringTheMissionReactor
    
    cameraManager.attachPreview(to: previewView) // previewView에 카메라 프리뷰 연결
    cameraManager.startSession() // 카메라 세션 시작
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    rootFlexContainer.pin
      .all(view.pin.safeArea)
    rootFlexContainer.flex
      .layout()
    
    noticeLabelChip.flex
      .markDirty()
  }
  
  // MARK: - Methods
  
  public func configureAttribute() {
    view.backgroundColor = UIColor(hex: 0x1b1b1b)
    
    view.addSubview(rootFlexContainer)
    [navigationContainer, cameraContainer, noticeContainer, controlContainer].forEach {
      rootFlexContainer.addSubview($0)
    }
    
    navigationContainer.addSubview(closeButton)
    
    cameraContainer.addSubview(cameraPreviewView)
    cameraPreviewView.addSubview(previewView)
    previewView.frame = cameraPreviewView.bounds
    previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    noticeContainer.addSubview(noticeLabelChip)
    
    controlContainer.addSubview(captureButton)
    controlContainer.addSubview(switchCameraButton)
  }
  
  public func configureLayout() {
    rootFlexContainer.flex.define { flex in
      flex.addItem(navigationContainer)
        .direction(.row)
        .justifyContent(.start)
        .marginTop(26)
        .marginHorizontal(10)
        .define { flex in
          flex.addItem(closeButton).size(40)
        }
      
      flex.addItem(cameraContainer)
        .alignSelf(.center)
        .marginTop(70)
        .aspectRatio(1)
        .width(100%)
        .maxWidth(UIScreen.main.bounds.width - 16)
        .define { flex in
          flex.addItem(cameraPreviewView).grow(1)
        }
      
      flex.addItem(noticeContainer)
        .alignSelf(.center)
        .marginTop(20)
        .define { flex in
          flex.addItem(noticeLabelChip)
        }
      
      flex.addItem().grow(1) // 하단 여백을 위한 빈 공간
      
      flex.addItem(controlContainer)
        .direction(.row)
        .justifyContent(.spaceBetween)
        .alignItems(.center)
        .marginBottom(36)
        .marginHorizontal(40)
        .define { flex in
          flex.addItem().size(48)
          flex.addItem(captureButton).size(74)
          flex.addItem(switchCameraButton).size(48)
        }
    }
  }
  
  private func configurePinchGesture() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction))
    self.cameraPreviewView.addGestureRecognizer(pinchGesture)
  }
  
  @objc private func pinchAction(_ sender: UIPinchGestureRecognizer) {
    guard let device = self.cameraManager.captureDevice else { return }
    
    do {
      try device.lockForConfiguration()
      defer { device.unlockForConfiguration() }
      
      let maxZoomFactor = device.activeFormat.videoMaxZoomFactor
      let pinchVelocityDividerFactor: CGFloat = 10.0
      
      let desiredZoomFactor = device.videoZoomFactor + atan2(sender.velocity, pinchVelocityDividerFactor)
      device.videoZoomFactor = max(1.0, min(desiredZoomFactor, maxZoomFactor))
    } catch {
      print("Error locking configuration")
    }
  }
}

extension CameraShootDuringTheMissionViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    /// 사진 찍기 결과
    cameraManager.photoCapturedSubject
      .map{ Reactor.Action.photoCaptured($0)}
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    /// 닫기 버튼 탭 처리
    closeButton.rx.tapped
      .map{ Reactor.Action.backButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    /// CameraManager의 사진 촬영 이벤트를 구독
    captureButton.rx.tapped
      .subscribe(with: self,onNext: { owner, _ in
        owner.cameraManager.capturePhoto()
      })
      .disposed(by: disposeBag)
    
    /// 카메라 전환 버튼 탭 처리
    switchCameraButton.rx.tapped
      .subscribe(with: self, onNext: { owner, _ in
        owner.cameraManager.switchCamera()
      })
      .disposed(by: disposeBag)
  }
}
