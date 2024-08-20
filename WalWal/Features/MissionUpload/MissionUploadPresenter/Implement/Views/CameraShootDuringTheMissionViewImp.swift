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
  
  private let rootFlexContainer = UIView()
  private let navigationContainer = UIView()
  private let shotContainerView = UIView()
  
  private let closeButton = WalWalTouchArea(
    image: Images.closeL.image,
    size: 40
  )
  
  private let cameraPreviewView = UIView()
  
  private let previewView = UIView()
  
  private let noticeLabelChip = WalWalChip(
    text: "반려동물과 함께 산책한 사진을 찍어요!",
    opacity: 0.9,
    image: Images.flagS.image,
    style: .semiFilled
  )
  
  private var captureButton = WalWalTouchArea(
    image: Assets.cameraPosSwipe.image,
    size: 74
  )
  
  private var switchCameraButton = WalWalTouchArea(
    image: Assets.cameraCapture.image,
    size: 48
  )
  
  private let cameraManager: CameraManager
  
  public init(
    reactor: R
  ) {
    self.cameraShootingDuringTheMissionReactor = reactor
    self.cameraManager = CameraManager()
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
  }
  
  // MARK: - Methods
  
  public func configureAttribute() {
    view.backgroundColor = Colors.black.color
    
    view.addSubview(rootFlexContainer)
    [navigationContainer, cameraPreviewView, noticeLabelChip, shotContainerView].forEach {
      rootFlexContainer.addSubview($0)
    }
    
    cameraPreviewView.addSubview(previewView)
    previewView.frame = cameraPreviewView.bounds
    previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  public func configureLayout() {
    
    rootFlexContainer.flex
      .direction(.column)
      .justifyContent(.center)
    
    navigationContainer.flex
      .direction(.row)
      .justifyContent(.start)
      .define { flex in
        flex.addItem(closeButton)
          .margin(26, 10, 0, 0)
          .size(40)
      }
    
    let cameraSize = UIScreen.main.bounds.width - 16
    cameraPreviewView.flex
      .size(cameraSize)
      .alignItems(.center)
      .marginTop(70)
    
    noticeLabelChip.flex
      .marginTop(20)
      .alignItems(.center)
    
    shotContainerView.flex
      .direction(.row)
      .justifyContent(.spaceEvenly)
      .marginBottom(36)
      .define { flex in
        flex.addItem()
          .size(48)
        flex.addItem(captureButton)
          .margin(0, 10, 0, 0)
          .size(74)
        flex.addItem(switchCameraButton)
          .size(48)
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
    // 사진 찍기 결과
    cameraManager.photoCapturedSubject
      .map{ Reactor.Action.photoCaptured($0)}
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 닫기 버튼 탭 처리
    closeButton.rx.tapped
      .map{ Reactor.Action.backButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.capturedPhoto }
      .distinctUntilChanged()
      .compactMap { $0 }
      .subscribe(onNext: { [weak self] image in
        self?.handleCapturedPhoto(image: image)
      })
      .disposed(by: disposeBag)
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

extension CameraShootDuringTheMissionViewControllerImp {
  // 사진이 찍힌 후의 처리 로직 (예시로 이미지 저장 또는 표시)
  private func handleCapturedPhoto(image: UIImage) {
    let imageView = UIImageView(image: image)
    imageView.frame = view.bounds
    view.addSubview(imageView)
  }
}
