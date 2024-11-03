//
//  BubbleView.swift
//  MissionPresenter
//
//  Created by 이지희 on 8/8/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//
import UIKit
import ResourceKit

import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa
public final class BubbleView: UIView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let containerView = UIView()
  private let contentContainerView = UIView() // 새로운 컨테이너 추가
  private let iconImageView = UIImageView().then {
    $0.image = Images.missionStartIcon.image
  }
  private let titleLabel = UILabel().then {
    $0.textColor = Colors.walwalOrange.color
    $0.font = Fonts.KR.H6.B
    $0.numberOfLines = 1
  }
  
  // MARK: - Property
  private var tipView: CAShapeLayer? = nil
  private var tipWidth: CGFloat = Const.tipHeight
  private var tipHeight: CGFloat = Const.tipHeight
  public var missionCount = BehaviorRelay<Int>(value: 0)
  public var isCompleted = BehaviorRelay<Bool>(value: false)
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  public init() {
    super.init(frame: .zero)
    self.backgroundColor = Colors.gray150.color
    
    configureAttribute()
    configureLayout()
    
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycles
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = containerView.bounds.height / 2
    
    containerView.sizeToFit()
    
    self.flex.layout()
    containerView.flex.layout()
    
    setTipShape(viewColor: self.backgroundColor ?? .clear, tipWidth: tipWidth, tipHeight: tipHeight)
  }
  
  // MARK: - Method
  
  override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return false
  }
  
  private func configureAttribute() {
    self.addSubview(containerView)
    containerView.addSubview(contentContainerView) // 새로운 컨테이너를 containerView에 추가
    contentContainerView.addSubview(iconImageView)
    contentContainerView.addSubview(titleLabel)
  }
  
  private func configureLayout() {
    // containerView 레이아웃 설정
    containerView.flex
      .paddingVertical(Const.verticalPadding)
      .paddingHorizontal(20.adjustedWidth)
      .alignItems(.center)
      .justifyContent(.center)
    
    // contentContainerView 레이아웃 설정 (수평 정렬)
    contentContainerView.flex
      .direction(.row)
      .alignItems(.center)
      .justifyContent(.center)
    
    // iconImageView와 titleLabel 레이아웃 설정
    iconImageView.flex
      .size(Const.iconSize)
      .marginRight(4.adjustedWidth)
    
    titleLabel.flex
      .height(Const.iconSize)
      .grow(1)
  }
  
  private func bind() {
    Observable.combineLatest(missionCount, isCompleted)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, data in
        let (count, completed) = data
        owner.titleLabel.text = completed ? "\(count)번째 미션을 완료했어요!" : "\(count+1)번째 미션을 함께 수행해볼까요?"
        
        owner.titleLabel.flex.markDirty()
        owner.contentContainerView.flex.markDirty()
        owner.containerView.flex.markDirty()
        
        owner.setNeedsLayout()
      }
      .disposed(by: disposeBag)
  }
  
  private func setTipShape(viewColor: UIColor, tipWidth: CGFloat, tipHeight: CGFloat) {
    let tipStartX = (containerView.bounds.width - tipWidth) / 2.0
    let tipStartY = containerView.bounds.height
    let radius: CGFloat = 2.0
    
    let path = CGMutablePath()
    
    let point1 = CGPoint(x: tipStartX, y: tipStartY - 7.0)
    let point2 = CGPoint(x: tipStartX + tipWidth, y: tipStartY - 7.0)
    let point3 = CGPoint(x: tipStartX + tipWidth / 2.0, y: tipStartY + tipHeight - 7.0)
    
    path.move(to: CGPoint(x: tipStartX, y: tipStartY - 2.0))
    path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
    path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)
    path.addArc(tangent1End: point3, tangent2End: point1, radius: radius)
    path.closeSubpath()
    
    let shape = CAShapeLayer()
    shape.path = path
    shape.fillColor = viewColor.cgColor
    
    if tipView == nil {
      tipView = shape
      self.layer.insertSublayer(shape, at: 0)
    } else {
      tipView?.path = path
    }
  }
  
  func startFloatingAnimation() {
    let moveAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
    
    moveAnimation.values = [0, -10, 0]
    moveAnimation.keyTimes = [0, 0.4, 1]
    moveAnimation.duration = 1.5
    moveAnimation.timingFunctions = [
      CAMediaTimingFunction(name: .easeOut),
      CAMediaTimingFunction(name: .easeIn)
    ]
    
    moveAnimation.autoreverses = true
    moveAnimation.repeatCount = .infinity
    
    self.layer.add(moveAnimation, forKey: "moveUpDown")
  }
  
  func stopFloatingAnimation() {
    self.layer.removeAnimation(forKey: "moveUp")
  }
}
