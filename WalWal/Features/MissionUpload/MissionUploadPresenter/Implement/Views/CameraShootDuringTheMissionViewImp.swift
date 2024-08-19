//
//  MissionUploadViewControllerImp.swift
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

public final class MissionUploadViewControllerImp<R: CameraShootDuringTheMissionReactor>: UIViewController, CameraShootDuringTheMissionViewController {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  public var disposeBag = DisposeBag()
  public var cameraShootingDuringTheMissionReactor: R
  
  
  private let navigationBar = WalWalNavigationBar(
    leftItems: [.close],
    title: nil,
    rightItems: []
  )
  
  private let cameraPreviewView = UIView()
  
  private let noticeLabelChip = WalWalChip(
    text: "반려동물과 함께 산책한 사진을 찍어요!",
    opacity: 0.9,
    image: Images.flagS.image,
    style: .semiFilled
  )
  
  private var instructionLabel: UILabel!
  private var captureButton: UIButton!
  private var switchCameraButton: UIButton!
  private var previewView: UIView!
  
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
    setAttribute()
    setLayout()
    self.reactor = self.cameraShootingDuringTheMissionReactor
  }
    
  
  public func setAttribute() {
   
  }
  
  public func setLayout() {
    
    cameraManager.attachPreview(to: previewView)
  }
}

extension MissionUploadViewControllerImp: View {
  
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
    
    // 카메라 전환 버튼 탭 처리
    switchCameraButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.cameraManager.switchCamera()
      })
      .disposed(by: disposeBag)
    
    // 닫기 버튼 탭 처리
    closeButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.dismiss(animated: true, completion: nil)
      })
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
    // CameraManager의 사진 촬영 이벤트를 구독
    captureButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.cameraManager.capturePhoto()
      })
      .disposed(by: disposeBag)
    
  }
}

extension MissionUploadViewControllerImp {
  // 사진이 찍힌 후의 처리 로직 (예시로 이미지 저장 또는 표시)
  private func handleCapturedPhoto(image: UIImage) {
    let imageView = UIImageView(image: image)
    imageView.frame = view.bounds
    view.addSubview(imageView)
  }
}
