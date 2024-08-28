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
  
  private let containerView = UIView()
  
  private let topContainerView = UIView()
  /// 미션 미리보기
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
  
  /// 미션 내용 가이드
  private let contentsGuideContainerView = UIView()
  private let contentsImageView = UIImageView().then {
    $0.image = Assets.missionCoach.image
  }
  private let missionContentLabel = CustomLabel(text: " 미션 내용을\n확인해 보아요!", font: Fonts.KR.H5.B).then {
    $0.asColor(targetString: "미션 내용", color: Colors.walwalOrange.color)
    $0.textColor = Colors.white.color
    $0.numberOfLines = 2
    $0.textAlignment = .right
  }
  
  private let contentArrowImageView = UIImageView().then {
    $0.image = Assets.contentsArrow.image
  }
  
  
  /// 미션 시작 가이드
  private let recordGuideContainerView = UIView()
  private let recordImageView = UIImageView().then {
    $0.image = Assets.missionCoachCam.image
  }
  private let cameraLabel = CustomLabel(text: "미션 사진을\n바로 찍을 수 있어요", font: Fonts.KR.H5.B).then {
    $0.asColor(targetString: "미션 사진", color: Colors.walwalOrange.color)
    $0.textColor = Colors.white.color
    $0.numberOfLines = 2
    $0.textAlignment = .right
  }
  
  private let cameraArrowImageView = UIImageView().then {
    $0.image = Assets.recordArrow.image
  }
  
  private let missionStartButton = WalWalButton_Icon(
    type: .active,
    title: "미션 시작하기",
    icon: Images.flagL.image
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
    
    containerView.pin.all()
    containerView.flex.layout()
    animateShow()
  }
  
  // MARK: - Layout Helper
  
  private func setupView() {
    backgroundColor = Colors.black.color.withAlphaComponent(0.75)
    missionContentView.backgroundColor = Colors.white.color
    missionContentView.layer.cornerRadius = 20
    missionContentView.clipsToBounds = true
    missionContentView.layer.borderColor = Colors.walwalOrange.color.cgColor
    missionContentView.layer.borderWidth = 3
    
    [containerView, topContainerView, recordGuideContainerView].forEach {
      addSubview($0)
    }
    
    [contentsGuideContainerView, missionContentView].forEach {
      topContainerView.addSubview($0)
    }
    
    setupLayout()
  }
  
  private func setupLayout() {
    containerView.flex
      .width(100%)
      .define {
        $0.addItem(cancelButton)
          .alignSelf(.end)
          .marginTop(38.adjusted)
          .marginRight(14.adjusted)
        $0.addItem(topContainerView)
        $0.addItem(recordGuideContainerView)
          .alignSelf(.end)
          .marginRight(41.adjusted)
          .marginTop(15.adjusted)
        $0.addItem(missionStartButton)
          .height(50.adjusted)
          .marginTop(13.adjusted)
          .marginHorizontal(20.adjusted)
      }
    
    topContainerView.flex
      .direction(.columnReverse)
      .define {
        $0.addItem(missionContentView)
          .marginTop(-19.adjusted)
          .marginHorizontal(20.adjusted)
        $0.addItem(contentsGuideContainerView)
          .alignSelf(.start)
          .marginLeft(62.adjusted)
          .marginTop(11.adjusted)
      }
    
    missionContentView.flex
      .size(.init(width: 342.adjusted, height: 407.adjusted))
      .define {
        $0.addItem(todayMissionLabel)
          .marginTop(42.adjusted)
          .marginHorizontal(3)
          .alignSelf(.center)
        $0.addItem(missionTitleLabel)
          .alignSelf(.center)
        $0.addItem(missionImageView)
          .marginHorizontal(21.adjusted)
      }
    
    contentsGuideContainerView.flex
      .width(159.adjusted)
      .direction(.row)
      .alignItems(.start)
      .define {
        $0.addItem(contentsImageView)
        $0.addItem(missionContentLabel)
          .marginLeft(-12.adjusted)
          .marginRight(9.adjusted)
        $0.addItem(contentArrowImageView)
          .marginTop(14.adjusted)
      }
    
    recordGuideContainerView.flex
      .width(182)
      .direction(.row)
      .alignItems(.start)
      .define {
        $0.addItem(cameraArrowImageView)
          .marginRight(11.adjusted)
          .marginTop((3.6).adjusted)
        $0.addItem(recordImageView)
        $0.addItem(cameraLabel)
          .marginLeft(-46.adjusted)
      }
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
    }
  }
}
