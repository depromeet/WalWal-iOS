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
  private let iconImageView = UIImageView()
  private let titleLabel = UILabel().then {
    $0.textColor = Colors.walwalOrange.color
    $0.font = Fonts.KR.H6.B
    $0.numberOfLines = 0
  }
  
  // MARK: - Property
  
  private var tipWidth: CGFloat = 16
  private var tipHeight: CGFloat = 16
  private var text: String = ""
  
  // MARK: - Initializers
  
  public init(
    color: UIColor,
    image: UIImage? = nil,
    text: String
  ) {
    super.init(frame: .zero)
    self.backgroundColor = color
    self.iconImageView.image = image
    self.titleLabel.text = text
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
}
