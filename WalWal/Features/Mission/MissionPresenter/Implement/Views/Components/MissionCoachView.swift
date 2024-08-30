//
//  MissionCoachView.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 8/28/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import DesignSystem

import PinLayout
import FlexLayout
import RxSwift
import RxCocoa

final class MissionCoachMarkView: UIView {
  
  private typealias Assets = ResourceKitAsset.Assets
  private typealias Images = ResourceKitAsset.Images
  private typealias Sample = ResourceKitAsset.Sample
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  //MARK: - UI
  
  private let rootContainerView = UIView()
  
  // 상단 컨테이너
  private let topContainerView = UIView()
  
  // 미션 미리보기 컨테이너
  private let missionPreviewContainer = UIView()
  private let missionContentView = UIView()
  private let todayMissionLabel = UILabel().then {
    $0.text = "오늘의 미션"
    $0.font = Fonts.KR.H7.B
    $0.textColor = Colors.walwalOrange.color
  }
  
  private let missionTitleLabel = CustomLabel(text: "반려동물과 함께\n공놀이한 사진을 찍어요!", font: Fonts.KR.H3).then {
    $0.textAlignment = .center
    $0.textColor = Colors.black.color
    $0.numberOfLines = 2
  }
  private let missionImageView = UIImageView().then {
    $0.image = Sample.missionSample.image
    $0.contentMode = .scaleAspectFit
  }
  
  // 미션 내용 가이드 컨테이너
  private let contentsGuideContainer = UIView()
  
  private let contentsImageViewContainer = UIView()
  private let contentsImageView = UIImageView().then {
    $0.image = Assets.missionCoach.image
    $0.contentMode = .scaleAspectFit
  }
  
  private let missionContentLabelContainer = UIView()
  private let missionContentLabel = CustomLabel(text: " 미션 내용을\n확인해 보아요!", font: Fonts.KR.H5.B).then {
    $0.textColor = Colors.white.color
    $0.asColor(targetString: "미션 내용", color: Colors.walwalOrange.color)
    $0.numberOfLines = 2
    $0.textAlignment = .right
  }
  
  private let contentArrowImageViewContainer = UIView()
  private let contentArrowImageView = UIImageView().then {
    $0.image = Assets.contentsArrow.image
    $0.contentMode = .scaleAspectFit
  }
  
  // 미션 시작 가이드 컨테이너
  private let recordGuideContainerWrapper = UIView()
  
  private let recordImageViewContainer = UIView()
  private let recordImageView = UIImageView().then {
    $0.image = Assets.missionCoachCam.image
    $0.contentMode = .scaleAspectFit
  }
  
  private let cameraLabelContainer = UIView()
  private let cameraLabel = CustomLabel(text: "미션 사진을\n바로 찍을 수 있어요", font: Fonts.KR.H5.B).then {
    $0.textColor = Colors.white.color
    $0.asColor(targetString: "미션 사진", color: Colors.walwalOrange.color)
    $0.numberOfLines = 2
    $0.textAlignment = .right
  }
  
  private let cameraArrowImageViewContainer = UIView()
  private let cameraArrowImageView = UIImageView().then {
    $0.image = Assets.recordArrow.image
    $0.contentMode = .scaleAspectFit
  }
  
  // 버튼 컨테이너
  private let buttonContainer = UIView()
  private let missionStartButton = WalWalButton_Icon(
    type: .active,
    title: "미션 시작하기",
    icon: Images.flagS.image
  )
  private let cancelButton = WalWalTouchArea(image: Images.closeL.image, size: 40.adjusted)
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainerView.pin.all()
    rootContainerView.flex.layout()
  }
  
  // MARK: - Layout Helper
  
  private func setupView() {
    backgroundColor = Colors.black.color.withAlphaComponent(0.75)
    missionContentView.backgroundColor = Colors.white.color
    missionContentView.layer.cornerRadius = 20
    missionContentView.clipsToBounds = true
    missionContentView.layer.borderColor = Colors.walwalOrange.color.cgColor
    missionContentView.layer.borderWidth = 3
    
    addSubview(rootContainerView)
    
    setupLayout()
  }
  
  private func setupLayout() {
    let safeAreaBottom = UIWindow.key?.safeAreaInsets.bottom
    let safeAreaTop = UIWindow.key?.safeAreaInsets.top
    rootContainerView.flex.define { flex in
      flex.addItem(cancelButton)
        .alignSelf(.end)
        .marginTop(38.adjusted)
        .marginRight(14.adjusted)
      flex.addItem(topContainerView)
        .top(-94.adjusted)
      flex.addItem(contentsGuideContainer)
        .position(.absolute)
        .marginLeft(62.adjusted)
        .marginTop(88.adjusted)
      flex.addItem(recordGuideContainerWrapper)
        .position(.absolute)
        .bottom(30.adjusted + 68 + (safeAreaBottom ?? 0) + 50)
        .right(40.adjusted)
      flex.addItem(buttonContainer)
        .position(.absolute)
        .bottom(30.adjusted + 68 + (safeAreaBottom ?? 0))
        .width(100%)
    }
    
    topContainerView.flex
      .direction(.columnReverse)
      .define { flex in
        flex.addItem(missionPreviewContainer)
          .marginTop(-19.adjusted)
          .marginHorizontal(16.adjusted)
      }
    
    missionPreviewContainer.flex.define { flex in
      flex.addItem(missionContentView)
    }
    
    missionContentView.flex.define { flex in
      flex.addItem(todayMissionLabel)
        .alignSelf(.center)
        .marginTop(42.adjusted)
      flex.addItem(missionTitleLabel)
        .alignSelf(.center)
        .marginTop(4.adjusted)
      flex.addItem(missionImageView)
        .alignSelf(.center)
        .width(300.adjusted)
        .height(264.adjusted)
        .marginHorizontal(21.adjusted)
      flex.addItem()
        .height(10.adjusted)
    }
    
    contentsGuideContainer.flex
      .direction(.row)
      .define { flex in
        flex.addItem(contentsImageViewContainer)
        flex.addItem(missionContentLabelContainer)
          .left(-20)
          .top(4)
        flex.addItem(contentArrowImageViewContainer)
          .left(-20)
          .top(20)
      }
    
    contentsImageViewContainer.flex
      .define { flex in
        flex.addItem(contentsImageView)
          .size(24)
      }
    
    missionContentLabelContainer.flex
      .define { flex in
        flex.addItem(missionContentLabel)
      }
    
    contentArrowImageViewContainer.flex
      .define { flex in
        flex.addItem(contentArrowImageView)
          .size(68)
      }
    
    recordGuideContainerWrapper.flex
      .width(184)
      .direction(.row)
      .alignItems(.start)
      .define { flex in
        flex.addItem(cameraArrowImageViewContainer)
        flex.addItem(recordImageViewContainer)
          .marginLeft(14)
          .top(4)
        flex.addItem(cameraLabelContainer)
          .top(7)
          .marginLeft(-49)
      }
    
    cameraArrowImageViewContainer.flex
      .define { flex in
        flex.addItem(cameraArrowImageView)
          .size(66)
      }
    
    recordImageViewContainer.flex
      .define { flex in
        flex.addItem(recordImageView)
          .size(24)
      }
    
    cameraLabelContainer.flex
      .define { flex in
        flex.addItem(cameraLabel)
      }
    
    buttonContainer.flex.define { flex in
      flex.addItem(missionStartButton)
        .height(50)
        .marginHorizontal(20.adjusted)
    }
    
    animateShow()
  }
  
  private func bind() {
    cancelButton.rx.tapped
      .bind { [weak self] in
        self?.hideCoachMarkView()
      }
      .disposed(by: disposeBag)
  }
  
  @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    if gesture.state == .began {
      hideCoachMarkView()
    }
  }
  
  private func animateShow() {
    self.alpha = 0
    self.isHidden = false
    
    UIView.animate(withDuration: 1) {
      self.alpha = 1
    }
  }
  
  private func hideCoachMarkView() {
    UIView.animate(withDuration: 0.5, animations: {
      self.alpha = 0
    }) { _ in
      self.isHidden = true
      UserDefaults.setValue(value: false, forUserDefaultKey: .isFirstMissionAppear)
      self.removeFromSuperview()
    }
  }
}
