//
//  CoachMarkView.swift
//  FeedPresenterImp
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

final class FeedCoachMarkView: UIView {
  
  private typealias Assets = ResourceKitAsset.Assets
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  //MARK: - UI
  
  private let containerView = UIView()
  private let guideContainerView = UIView()
  private let titleView = UILabel().then {
    $0.font = Fonts.KR.H5.B
    $0.text = """
사진을 꾸욱 눌러
귀여운 반려동물 사진에
반응 해보세요!
"""
    $0.asColor(targetString: "꾸욱", color: Colors.walwalOrange.color)
    $0.textColor = Colors.white.color
    $0.numberOfLines = 3
    $0.textAlignment = .center
  }
  
  private let arrowImageView = UIImageView().then {
    $0.image = Assets.coachArrow.image
  }
  private let coachImageView = UIImageView().then {
    $0.image = Assets.coachImage.image
  }
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
    guideContainerView.layer.cornerRadius = 20
    guideContainerView.clipsToBounds = true
    guideContainerView.layer.borderColor = Colors.walwalOrange.color.cgColor
    guideContainerView.layer.borderWidth = 3
    
    addSubview(containerView)
    addSubview(guideContainerView)
    setupLayout()
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    addGestureRecognizer(longPressGesture)
  }
  
  private func setupLayout() {
    containerView.flex
      .define {
        $0.addItem(cancelButton)
          .alignSelf(.end)
          .marginTop(46.adjusted)
          .marginRight(14.adjusted)
        $0.addItem(guideContainerView)
          .marginTop(59.adjusted)
          .alignSelf(.center)
      }
    
    guideContainerView.flex
      .alignItems(.center)
      .justifyContent(.center)
      .size(.init(width: 343.adjusted, height: 504.adjusted))
      .define {
        $0.addItem(titleView)
        $0.addItem(arrowImageView)
          .marginTop(-12.adjusted)
          .marginStart(117.adjusted)
        $0.addItem(coachImageView)
          .marginTop(-32.adjusted)
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
      UserDefaults.setValue(value: false, forUserDefaultKey: .isFirstFeedAppear)
    }
  }
}
