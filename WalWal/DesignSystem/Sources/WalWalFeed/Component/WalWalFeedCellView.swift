//
//  WalWalFeedCellView.swift
//  DesignSystem
//
//  Created by 이지희 on 8/3/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import Then
import FlexLayout
import PinLayout
import RxSwift

final class WalWalFeedCellView: UIView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - Components
  private let containerView = UIView().then {
    $0.layer.cornerRadius = 20
    $0.clipsToBounds = true
    $0.backgroundColor = Colors.white.color
    $0.addBorder(with: Colors.gray200.color, width: 1)
  }
  
  private let profileHeaderView = UIView()
  private let profileInfoView = UIView()
  private let feedContentView = UIView()
  private let boostLabelView = UIView()
  
  private let profileImageView = UIImageView().then {
    $0.layer.cornerRadius = 20
    $0.clipsToBounds = true
  }
  
  private let userNickNameLabel = UILabel().then {
    $0.font = Fonts.KR.H7.B
    $0.textColor = Colors.black.color
  }
  
  private let missionLabel = UILabel().then {
    $0.font = Fonts.KR.B2
    $0.textColor = Colors.gray700.color
  }
  
  private let followButton = WalWalChip(
    text: "팔로우",
    style: .filled,
    selectedStyle: .outlined,
    font: Fonts.KR.B2
  )
  
  private let missionImageView = UIImageView()
  
  private let missionDateChip = WalWalChip(opacity: 0.5, style: .filled)
  
  private let boostIconImageView = UIImageView().then {
    $0.image = ResourceKitAsset.Sample.fire.image
  }
  
  private let boostCountLabel = UILabel().then {
    $0.font = Fonts.KR.B2
    $0.textColor = Colors.gray500.color
  }
  
  private let boostLabel = UILabel().then {
    $0.text = "부스터"
    $0.font = Fonts.EN.Caption
    $0.textColor = Colors.gray500.color
  }
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setAttributes()
    setLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is not implemented")
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin
      .all()
    containerView.flex
      .layout()
  }
  
  // MARK: - Methods
  
  func configureFeed(feedData: WalWalFeedModel) {
    followButton.alpha = feedData.isFeedCell ? 1 : 0
    missionDateChip.rx.text.onNext(feedData.date)
    userNickNameLabel.text = feedData.nickname
    missionLabel.text = feedData.missionTitle
    profileImageView.image = feedData.profileImage
    missionImageView.image = feedData.missionImage
    boostCountLabel.text = "\(feedData.boostCount)"
  }
  
  private func setAttributes() {
    addSubview(containerView)
    
    [profileHeaderView, feedContentView].forEach {
      containerView.addSubview($0)
    }
    
    [profileImageView, profileInfoView, followButton].forEach {
      profileHeaderView.addSubview($0)
    }
    
    [userNickNameLabel, missionLabel].forEach {
      profileInfoView.addSubview($0)
    }
    
    [missionImageView, missionDateChip, boostLabelView].forEach {
      feedContentView.addSubview($0)
    }
    
    [boostIconImageView, boostCountLabel, boostLabel].forEach {
      boostLabelView.addSubview($0)
    }
  }
  
  private func setLayouts() {
    containerView.flex
      .define {
        $0.addItem(profileHeaderView)
          .margin(20, 20)
        $0.addItem(feedContentView)
      }
    
    profileHeaderView.flex
      .direction(.row)
      .alignItems(.center)
      .width(100%)
      .define {
        $0.addItem(profileImageView)
          .size(40)
        $0.addItem(profileInfoView)
          .marginLeft(10)
          .width(180)
        $0.addItem(followButton)
          .marginLeft(10)
      }
    
    profileInfoView.flex
      .define {
        $0.addItem(userNickNameLabel)
          .marginBottom(2)
        $0.addItem(missionLabel)
      }
    
    feedContentView.flex
      .direction(.column)
      .justifyContent(.center)
      .define {
        $0.addItem(missionImageView)
          .size(343)
          .position(.relative)
        $0.addItem(missionDateChip)
          .position(.absolute)
          .top(12)
          .alignSelf(.center)
        $0.addItem(boostLabelView)
          .marginTop(15)
          .marginLeft(20)
          .marginBottom(16)
      }
    
    boostLabelView.flex
      .direction(.row)
      .define {
        $0.addItem(boostIconImageView)
        $0.addItem(boostCountLabel)
        $0.addItem(boostLabel)
      }
  }
}
