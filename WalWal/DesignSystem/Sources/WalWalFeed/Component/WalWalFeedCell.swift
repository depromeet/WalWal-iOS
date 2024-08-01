//
//  WalWalFeedCell.swift
//  DesignSystem
//
//  Created by 이지희 on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import Utility
import ResourceKit

import Then
import FlexLayout
import PinLayout
import RxSwift

final class WalWalFeedCell: UICollectionViewCell {
  
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias FontEN = ResourceKitFontFamily.EN
  private typealias AssetColor = ResourceKitAsset.Colors
  private typealias AssetImage = ResourceKitAsset.Assets
  
  // MARK: - Components
  private let containerView = UIView().then {
    $0.layer.cornerRadius = 20.adjusted
    $0.clipsToBounds = true
  }
  private let profileHeaderView = UIView()
  private let profileInfoView = UIView()
  private let feedContentView = UIView()
  private let boostLabelView = UIView()
  private let profileImageView = UIImageView().then {
    $0.layer.cornerRadius = 20.adjusted
    $0.clipsToBounds = true
  }
  private let userNickNameLabel = UILabel().then {
    $0.font = FontKR.H7.B
    $0.textColor = AssetColor.black.color
  }
  private let missionLabel = UILabel().then {
    $0.font = FontKR.B2
    $0.textColor = AssetColor.gray700.color
  }
  private let followButton = UIButton().then {
    $0.setTitle("팔로우", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = AssetColor.gray800.color
    $0.layer.cornerRadius = 14.adjusted
  }
  private let missionImageView = UIImageView()
  private let boostIconImageView = UIImageView().then {
    $0.image = ResourceKitAsset.Sample.fire.image
  }
  private let boostCountLabel = UILabel().then {
    $0.font = FontKR.B2
    $0.textColor = AssetColor.gray500.color
  }
  private let boostLabel = UILabel().then {
    $0.text = "부스트"
    $0.font = FontEN.Caption // 변경 필요
    $0.textColor = AssetColor.gray500.color
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
    containerView.pin.all()
    containerView.flex.layout()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  // MARK: - Methods
  
  func configureCell(
    nickName: String,
    missionTitle: String,
    profileImage: UIImage,
    missionImage: UIImage,
    boostCount: Int
  ) {
    userNickNameLabel.text = nickName
    missionLabel.text = missionTitle
    profileImageView.image = profileImage
    missionImageView.image = missionImage
    boostCountLabel.text = "\(boostCount)"
  }
  
  private func setAttributes() {
    
    containerView.addBorder(with: AssetColor.gray200, width: 1)
    containerView.roundCorners(cornerRadius: 20)
    
    contentView.addSubview(containerView)
    
    [profileHeaderView, feedContentView].forEach {
      containerView.addSubview($0)
    }
    
    [profileImageView, profileInfoView].forEach {
      profileHeaderView.addSubview($0)
    }
    
    [userNickNameLabel, missionLabel].forEach {
      profileInfoView.addSubview($0)
    }
    
    [missionImageView,boostLabelView].forEach {
      feedContentView.addSubview($0)
    }
    
    [boostIconImageView, boostCountLabel, boostLabel].forEach {
      boostLabelView.addSubview($0)
    }
  }
  
  private func setLayouts() {
    containerView
      .flex
      .define {
        $0.addItem(profileImageView)
          .size(40)
        $0.addItem(profileInfoView)
      }
    
    profileHeaderView
      .flex
      .direction(.row)
      .define {
        $0.addItem(profileImageView)
        $0.addItem(profileInfoView)
      }
    
    profileInfoView
      .flex
      .grow(1)
      .define {
        $0.addItem(userNickNameLabel)
        $0.addItem(missionLabel)
      }
    
    feedContentView
      .flex
      .direction(.column)
      .define {
        $0.addItem(missionImageView)
          .size(343)
        $0.addItem(boostLabelView)
      }
    
    boostLabelView
      .flex
      .direction(.row)
      .define {
        $0.addItem(boostIconImageView)
        $0.addItem(boostCountLabel)
        $0.addItem(boostLabel)
      }
  }
  
}
