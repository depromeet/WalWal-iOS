//
//  WalWalFeedCellView.swift
//  DesignSystem
//
//  Created by 이지희 on 8/3/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import Utility

import Then
import FlexLayout
import PinLayout
import RxSwift

final class WalWalFeedCellView: UIView {
  
  private typealias Images = ResourceKitAsset.Sample
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
    $0.contentMode = .scaleAspectFill
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
  
  private let missionImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private let boostIconImageView = UIImageView().then {
    $0.image = Images.fireDef.image
  }
  
  let contentLabel = UILabel().then {
    $0.textColor = Colors.black.color
    $0.font = Fonts.KR.B2
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 2
    $0.lineBreakMode = .byCharWrapping
  }
  
  private let boostCountLabel = UILabel().then {
    $0.font = Fonts.EN.B2
    $0.textColor = Colors.gray500.color
  }
  
  private let boostLabel = UILabel().then {
    $0.text = "부스터"
    $0.font = Fonts.KR.B2
    $0.textColor = Colors.gray500.color
  }
  
  private let missionDateLabel = UILabel().then {
    $0.font = Fonts.KR.B2
    $0.textColor = Colors.gray500.color
  }
  
  var isContentExpanded = false
  var maxLength = 55
  private var contents = ""
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    bind()
    setAttributes()
    setLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is not implemented")
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    boostCountLabel.flex
      .markDirty()
    
    missionDateLabel.flex
      .markDirty()
    
    boostLabelView.flex
      .markDirty()
    
    contentLabel.flex
      .markDirty()
    
    containerView.pin
      .all()
    
    containerView.flex
      .layout(mode: .adjustHeight)
    
  }
  
  // MARK: - Methods
  
  private func bind() {
    contentLabel.rx.tapped
      .subscribe(onNext: { [weak self] in
        self?.toggleContent()
      })
      .disposed(by: disposeBag) // DisposeBag에 추가
  }
  
  func configureFeed(feedData: WalWalFeedModel, isBoost: Bool = false) {
    userNickNameLabel.text = feedData.nickname
    missionLabel.text = feedData.missionTitle
    profileImageView.image = feedData.profileImage
    missionImageView.image = feedData.missionImage
    boostCountLabel.text = "\(feedData.boostCount)"
    let isBoostImage = isBoost ? ResourceKitAsset.Sample.fireActive.image : ResourceKitAsset.Sample.fireDef.image
    let isBoostColor = isBoost ? Colors.walwalOrange.color : Colors.gray500.color
    boostIconImageView.image = isBoostImage
    boostCountLabel.textColor = isBoostColor
    boostLabel.textColor = isBoostColor
    contentLabel.text = feedData.contents
    contentLabel.sizeToFit()
    
    let missionDate = feedData.date.toFormattedDate() ?? feedData.date
    let attributedString = NSMutableAttributedString(string: missionDate)
    
    let numberFont = Fonts.EN.Caption // 숫자에 적용할 폰트
    let defaultFont = Fonts.KR.B2 // 기본 폰트
    
    attributedString.addAttribute(.font, value: defaultFont, range: NSRange(location: 0, length: missionDate.count))
    
    let numberPattern = "[0-9]"
    if let regex = try? NSRegularExpression(pattern: numberPattern, options: []) {
      let matches = regex.matches(in: missionDate, options: [], range: NSRange(location: 0, length: missionDate.count))
      for match in matches {
        attributedString.addAttribute(.font, value: numberFont, range: match.range)
      }
    }
    
    missionDateLabel.attributedText = attributedString
    
    contents = feedData.contents
    
    guard let contentTextLength = self.contentLabel.text?.count else { return }
    if contentTextLength > maxLength {
      DispatchQueue.main.async {
        self.contentLabel.addTrailing(with: "...", moreText: "더 보기", moreTextFont: Fonts.KR.B2, moreTextColor: Colors.gray500.color)
      }
    }
  }
  
  private func setAttributes() {
    addSubview(containerView)
    
    [profileHeaderView, feedContentView].forEach {
      containerView.addSubview($0)
    }
    
    [profileImageView, profileInfoView].forEach {
      profileHeaderView.addSubview($0)
    }
    
    [userNickNameLabel, missionLabel].forEach {
      profileInfoView.addSubview($0)
    }
    
    [missionImageView, boostLabelView].forEach {
      feedContentView.addSubview($0)
    }
    
    [boostIconImageView, boostCountLabel, boostLabel, missionDateLabel].forEach {
      boostLabelView.addSubview($0)
    }
  }
  
  private func setLayouts() {
    contentLabel.flex.isIncludedInLayout(contentLabel.text != "")
    
    containerView.flex
      .define {
        $0.addItem(profileHeaderView)
          .marginHorizontal(16)
          .marginVertical(15)
        $0.addItem(feedContentView)
          .marginBottom(20)
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
      }
    
    profileInfoView.flex
      .define {
        $0.addItem(userNickNameLabel)
          .marginBottom(2)
        $0.addItem(missionLabel)
      }
    
    feedContentView.flex
      .width(100%)
      .direction(.column)
      .justifyContent(.center)
      .define {
        $0.addItem(missionImageView)
          .size(343)
          .position(.relative)
        $0.addItem(contentLabel)
          .minHeight(16)
          .marginHorizontal(16)
          .marginTop(14)
        $0.addItem(boostLabelView)
          .marginTop(8)
          .marginHorizontal(16)
      }
    
    boostLabelView.flex
      .width(100%)
      .direction(.row)
      .alignItems(.center)
      .define {
        $0.addItem(boostIconImageView)
        $0.addItem(boostCountLabel)
          .marginRight(1)
        $0.addItem(boostLabel)
          .marginRight(8)
        $0.addItem(missionDateLabel)
      }
  }
  
  private func toggleContent() {
    contentLabel.numberOfLines = 4
    contentLabel.text = contents
    setNeedsLayout()
  }
  
}
