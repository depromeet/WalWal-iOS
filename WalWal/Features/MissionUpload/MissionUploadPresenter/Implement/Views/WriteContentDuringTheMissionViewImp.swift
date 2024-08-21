//
//  WriteContentDuringTheMissionViewImp.swift
//  MissionUploadPresenter
//
//  Created by 조용인 on 8/21/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
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

public final class WriteContentDuringTheMissionViewControllerImp<R: WriteContentDuringTheMissionReactor>:
  UIViewController,
  WriteContentDuringTheMissionViewController {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Assets = ResourceKitAsset.Assets
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  private let backButton = WalWalTouchArea(
    image: Images.backL.image,
    size: 40
  )
  
  private lazy var previewImageView = UIImageView().then {
    $0.image = capturedImage
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 20
  }
  
  private lazy var contentTextView = StyledTextInputView(
    placeholderText: "오늘의 산책은 어땠나요?",
    maxCharacterCount: 80
  ).then {
    $0.layer.cornerRadius = 20
  }
  
  private let uploadButton = UIButton().then {
    $0.setTitle("업로드", for: .normal)
    $0.setTitleColor(Colors.white.color, for: .normal)
    $0.backgroundColor = Colors.blue.color
    $0.layer.cornerRadius = 10
  }
  public var disposeBag = DisposeBag()
  public var writeContentDuringTheMissionReactor: R
  
  private let capturedImage: UIImage
  
  public init(
    reactor: R,
    capturedImage: UIImage
  ) {
    self.writeContentDuringTheMissionReactor = reactor
    self.capturedImage = capturedImage
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
    self.reactor = self.writeContentDuringTheMissionReactor
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  // MARK: - Methods
  
  public func configureAttribute() {
    view.backgroundColor = Colors.black.color
  }
  
  public func configureLayout() {
    [backButton, previewImageView, contentTextView, uploadButton].forEach {
      view.addSubview($0)
    }
  }
  
  private func layoutView() {
    backButton.pin
      .top(view.safeAreaInsets.top + 16)
      .left(16)
      .size(40)
    
    previewImageView.pin
      .below(of: backButton).marginTop(16)
      .horizontally(16)
      .height(200)
    
    contentTextView.pin
      .below(of: previewImageView).marginTop(16)
      .horizontally(16)
      .height(150)
    
    uploadButton.pin
      .below(of: contentTextView).marginTop(16)
      .horizontally(16)
      .height(50)
  }
  
}

extension WriteContentDuringTheMissionViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    backButton.rx.tapped
      .map { Reactor.Action.backButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    uploadButton.rx.tap
      .withLatestFrom(contentTextView.rx.text)
      .withUnretained(self)
      .map { owner, content in
        Reactor.Action.uploadButtonTapped(
          capturedImage: owner.capturedImage,
          content: content
        )
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
   
  }
}
