//
//  RecordCarouselCell.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 9/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import DesignSystem
import RecordsDomain

import Then
import PinLayout
import FlexLayout
import Kingfisher
import RxSwift

final class RecordCarouselCell: UICollectionViewCell, ReusableView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  var disposeBag = DisposeBag()
  
  private var isRecordContainerVisible = true
  
  // MARK: - UI
  
  let rootContainer = UIView().then {
    $0.backgroundColor = Colors.white.color
    $0.layer.cornerRadius = 30.adjusted
    $0.clipsToBounds = true
    $0.layer.borderColor = Colors.white.color.cgColor
    $0.layer.borderWidth = 3
  }
  
  /// 그림자 설정
  private let shadowContainer = UIView().then {
    $0.layer.shadowColor = UIColor(hex: 0xCCCCCC, alpha: 0.4).cgColor
    $0.layer.shadowRadius = 15
    $0.layer.shadowOffset = CGSize(width: 0, height: 0)
    $0.layer.shadowOpacity = 1.0
  }
  
  let missionInfoContainer = UIView().then {
    $0.isHidden = true
  }
  
  /// 미션 기록 보기
  let recordContainer = UIView()
  
  let swapButton = UIButton().then {
    $0.setImage(Images.swapL.image.withTintColor(Colors.walwalOrange.color), for: .normal)
    $0.backgroundColor = Colors.white.color
    $0.layer.cornerRadius = 15.adjusted
  }
  private let recordimageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  private let dateChipView = UIView().then {
    $0.backgroundColor = Colors.black60.color
    $0.layer.cornerRadius = 15.adjusted
  }
  private let dateLabel = CustomLabel(font: Fonts.EN.H2).then {
    $0.textColor = Colors.white.color
  }
  public private(set) var textView = UnderlinedTextView(
    font: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14.adjusted)!,
    textColor: Colors.gray600.color,
    tintColor: Colors.walwalOrange.color,
    underLineColor: Colors.gray150.color,
    numberOfLines: 4,
    underLineHeight: 30.adjusted,
    lineSpacing: 0,
    enterSpacing: 14.adjusted
  ).then {
    $0.backgroundColor = Colors.white.color
    $0.isEditable = false
    $0.isScrollEnabled = false
    $0.textContainerInset = .zero
    $0.textContainer.lineFragmentPadding = 4
    $0.returnKeyType = .done
  }
  /// 미션 정보 보기
  private let todayMissionLabel = CustomLabel(font: Fonts.KR.H7.B).then {
    $0.text = "오늘의 미션"
    $0.textColor = Colors.walwalOrange.color
  }
  private let missionTitleLabel = CustomLabel(font: Fonts.KR.H4).then {
    $0.textColor = Colors.black.color
    $0.textAlignment = .center
    $0.numberOfLines = 5
  }
  private let missionImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  }
  
  // MARK: - Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    resetCell()
  }
  
  override func layoutSubviews() {
    shadowContainer.pin.all()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let touchLocation = touch.location(in: self)
      
      if swapButton.frame.contains(touchLocation) {
        toggleContainers()
        return
      }
    }
    super.touchesBegan(touches, with: event)
  }
  
  // MARK: - Layout
  
  private func configureUI() {
    configureAttribute()
    configureLayout()
    bind()
  }
  
  private func configureAttribute() {
    swapButton.isUserInteractionEnabled = true
    
    addSubview(shadowContainer)
    shadowContainer.addSubview(rootContainer)
    rootContainer.addSubview(recordContainer)
    rootContainer.addSubview(missionInfoContainer)
    
    recordimageView.addSubview(dateChipView)
    
    textView.configureAttributeText()
  }
  
  private func configureLayout() {
    rootContainer.flex
      .define { flex in
        flex.addItem(recordContainer)
          .position(.absolute)
          .width(100%)
          .height(100%)
        flex.addItem(missionInfoContainer)
          .position(.absolute)
          .width(100%)
          .height(100%)
        flex.addItem(swapButton)
      }
    
    recordContainer.flex
      .define { flex in
        flex.addItem(recordimageView)
          .size(255.adjusted)
        flex.addItem(textView)
          .height(100%)
          .marginTop(17.adjusted)
          .marginHorizontal(17.adjusted)
          .marginBottom(20.adjusted)
      }
    
    missionInfoContainer.flex
      .define{ flex in
        flex.addItem(missionImageView)
          .position(.absolute)
          .width(100%)
          .height(100%)
        flex.addItem(todayMissionLabel)
          .position(.absolute)
          .alignSelf(.center)
          .top(68.adjusted)
        flex.addItem(missionTitleLabel)
          .position(.absolute)
          .alignSelf(.center)
          .top(89.adjusted)
          .width(100%)
      }
    
    swapButton.flex
      .position(.absolute)
      .alignSelf(.end)
      .size(30.adjusted)
      .marginTop(18.adjusted)
      .right(18.adjusted)
    
    dateChipView.flex
      .position(.absolute)
      .alignSelf(.center)
      .alignItems(.center)
      .justifyContent(.center)
      .height(30.adjusted)
      .bottom(10.adjusted)
      .paddingHorizontal(12.adjusted)
      .define { flex in
        flex.addItem(dateLabel)
      }
  }
  
  // MARK: - Binding
  
  private func bind() {
    swapButton.rx.tap
      .throttle(
        .milliseconds(300),
        latest: false,
        scheduler: MainScheduler.instance
      )
      .bind(with: self) { owner, _ in
        owner.toggleContainers()
      }
      .disposed(by: disposeBag)
  }
  
  // MARK: - Custom Method
  
  private func toggleContainers() {
    isRecordContainerVisible.toggle()
    
    let fromView = isRecordContainerVisible ? missionInfoContainer : recordContainer
    let toView = isRecordContainerVisible ? recordContainer : missionInfoContainer
    
    let rotationAngle = CGFloat.pi / 2
    var transform = CATransform3DIdentity
    transform.m34 = -1.0 / 1200.0
    
    let rotatingContainer = rootContainer
    
    let originalPosition = rotatingContainer.layer.position
    
    rotatingContainer.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    rotatingContainer.layer.position = originalPosition
    
    UIView.animate(withDuration: 0.3, animations: {
      rotatingContainer.layer.transform = CATransform3DRotate(transform, rotationAngle, 0, 1, 0)
      fromView.alpha = 0
    }) { _ in
      fromView.isHidden = true
      rotatingContainer.layer.transform = CATransform3DIdentity
      
      toView.isHidden = false
      toView.alpha = 0
      rotatingContainer.layer.transform = CATransform3DRotate(transform, -rotationAngle, 0, 1, 0)
      
      UIView.animate(withDuration: 0.3, animations: {
        rotatingContainer.layer.transform = CATransform3DIdentity
        toView.alpha = 1
      }) { _ in
        self.setNeedsLayout()
      }
    }
  }
  
  private func resetCell() {
    isRecordContainerVisible = true
    recordContainer.isHidden = false
    missionInfoContainer.isHidden = true
    
    rootContainer.layer.transform = CATransform3DIdentity
    recordContainer.alpha = 1.0
    missionInfoContainer.alpha = 0.0
  }
  
  func configureCell(record: RecordList) {
    let recordImageProcessor = DownsamplingImageProcessor(size: CGSize(width: 255, height: 255))
    let missionImageProcessor = DownsamplingImageProcessor(size: CGSize(width: 255, height: 436))
    let round = RoundCornerImageProcessor(cornerRadius: 30.adjusted)
    
    self.textView.text = record.recordContent
    self.textView.textColor = Colors.gray600.color
    self.missionTitleLabel.text = record.missionTitle
    self.missionImageView.kf.setImage(
      with: URL(string: record.missionIllustrationURL),
      options: [
        .processor(missionImageProcessor),
        .processor(round),
        .scaleFactor(UIScreen.main.scale),
        .cacheOriginalImage
      ])
    self.recordimageView.kf.setImage(
      with: URL(string: record.recordImageURL),
      options: [
        .processor(recordImageProcessor),
        .scaleFactor(UIScreen.main.scale),
        .cacheOriginalImage,
        .transition(.fade(0.2))
      ])
    
    self.dateLabel.text = record.completedAt.replacingOccurrences(of: "-", with: ".")
  }
  
}
