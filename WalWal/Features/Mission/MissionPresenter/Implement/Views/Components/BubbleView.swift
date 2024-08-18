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

public final class BubbleView: UIView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let containerView = UIView()
  private let iconImageView = UIImageView().then {
    $0.image = Images.missionStartIcon.image
  }
  private let titleLabel = UILabel().then {
    $0.textColor = Colors.walwalOrange.color
    $0.font = Fonts.KR.H6.B
    $0.numberOfLines = 0
  }
  
  // MARK: - Property
  
  private var tipWidth: CGFloat = 16
  private var tipHeight: CGFloat = 16
  public var missionCount = BehaviorRelay<Int>(value: 0)
  public var isCompleted = BehaviorRelay<Bool>(value: false)
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  public init() {
    super.init(frame: .zero)
    self.backgroundColor =  Colors.gray150.color
    bind()
    configureAttribute()
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycles
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    configureAttribute()
    setTipShape(viewColor: self.backgroundColor ?? .clear, tipWidth: tipWidth, tipHeight: tipHeight)
  }
  
  // MARK: - Method
  
  private func configureAttribute() {
    self.addSubview(containerView)
    containerView.pin
      .all()
    
    layer.cornerRadius = containerView.bounds.height / 2
  }
  
  private func configureLayout() {
    containerView.flex
      .direction(.row)
      .alignItems(.center)
      .justifyContent(.center)
      .padding(9.5, 20)
      .define {
        if iconImageView.image != nil {
          $0.addItem(iconImageView)
            .marginRight(4)
        }
        $0.addItem(titleLabel)
          .height(19)
      }
  }
  
  private func bind() {
    Observable.combineLatest(missionCount, isCompleted)
      .map { count, completed -> String in
        return completed ? "\(count+1)번째 함께 미션을 완료했어요!" : "\(count+1)번째 미션을 함께 수행해볼까요?"
      }
      .bind(to: titleLabel.rx.text)
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
    
    path.move(to: CGPoint(x: tipStartX, y: tipStartY - 5.0))
    path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
    path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)
    path.addArc(tangent1End: point3, tangent2End: point1, radius: radius)
    path.closeSubpath()
    
    let shape = CAShapeLayer()
    shape.path = path
    shape.fillColor = viewColor.cgColor
    
    self.layer.insertSublayer(shape, at: 0)
    
  }
  
  func startFloatingAnimation() {
    let moveUp = CABasicAnimation(keyPath: "position.y")
    moveUp.fromValue = self.layer.position.y
    moveUp.toValue = self.layer.position.y - 10
    moveUp.duration = 1.5
    moveUp.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    moveUp.autoreverses = true
    moveUp.repeatCount = .infinity
    
    let scaleUp = CABasicAnimation(keyPath: "transform.scale")
    scaleUp.fromValue = 1.0
    scaleUp.toValue = 1.0
    scaleUp.duration = 1.5
    scaleUp.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    scaleUp.autoreverses = true
    scaleUp.repeatCount = .infinity
    
    let rotation = CABasicAnimation(keyPath: "transform.rotation")
    rotation.fromValue = -CGFloat.pi / 180
    rotation.toValue = CGFloat.pi / 180
    rotation.duration = 2.0
    rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    rotation.autoreverses = true
    rotation.repeatCount = .infinity
    
    self.layer.add(moveUp, forKey: "moveUp")
    self.layer.add(scaleUp, forKey: "scaleUp")
    self.layer.add(rotation, forKey: "rotation")
  }
  
  func stopFloatingAnimation() {
    self.layer.removeAnimation(forKey: "moveUp")
    self.layer.removeAnimation(forKey: "scaleUp")
    self.layer.removeAnimation(forKey: "rotation")
  }
}
