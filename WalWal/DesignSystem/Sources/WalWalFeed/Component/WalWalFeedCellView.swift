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
    $0.lineBreakStrategy = .hangulWordPriority
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
  
  var maxLength = 55
  public private(set) var contents = ""
  private let disposeBag = DisposeBag()
  private let moreTappedSubject = PublishSubject<Bool>()
  
  public var moreTapped: Observable<Bool> {
    return moreTappedSubject.asObservable()
  }
  
  public var isExpanded: Bool = false
  
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
    
    feedContentView.flex
      .markDirty()
    
    containerView.pin
      .all()
    
    containerView.flex
      .layout(mode: .adjustHeight)
    
  }
  
  // MARK: - Methods
  
  private func bind() {
    contentLabel.rx.tapped
      .withUnretained(self)
      .compactMap { _ in 
        self.isExpanded.toggle()
        self.toggleContent()
        return self.isExpanded
      }
      .bind(to: moreTappedSubject)
      .disposed(by: disposeBag)
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
    contents = sanitizeContent(feedData.contents)
    contentLabel.attributedText = applyLineHeight(to: contents, lineHeight: 16)
    
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
          .marginHorizontal(16.adjusted)
          .marginVertical(15.adjusted)
        $0.addItem(feedContentView)
          .marginBottom(20.adjusted)
      }
    
    profileHeaderView.flex
      .direction(.row)
      .alignItems(.center)
      .width(100%)
      .define {
        $0.addItem(profileImageView)
          .size(40)
        $0.addItem(profileInfoView)
          .marginLeft(10.adjusted)
      }
    
    profileInfoView.flex
      .define {
        $0.addItem(userNickNameLabel)
          .marginBottom(2.adjusted)
        $0.addItem(missionLabel)
      }
    
    feedContentView.flex
      .width(100%)
      .direction(.column)
      .justifyContent(.center)
      .define {
        $0.addItem(missionImageView)
          .height(343.adjusted)
          .alignItems(.center)
          .position(.relative)
        $0.addItem(contentLabel)
          .minHeight(16.adjusted)
          .marginHorizontal(16.adjusted)
          .marginTop(14.adjusted)
        $0.addItem(boostLabelView)
          .marginTop(8.adjusted)
          .marginHorizontal(16.adjusted)
      }
    
    boostLabelView.flex
      .width(100%)
      .direction(.row)
      .alignItems(.center)
      .define {
        $0.addItem(boostIconImageView)
        $0.addItem(boostCountLabel)
          .marginRight(1.adjusted)
        $0.addItem(boostLabel)
          .marginRight(8.adjusted)
        $0.addItem(missionDateLabel)
      }
  }
  
  func toggleContent() {
    contentLabel.numberOfLines = 4
    contentLabel.text = contents
    setNeedsLayout()
  }
  
  private func sanitizeContent(_ content: String) -> String {
    return content.replacingOccurrences(of: "\n", with: "")
  }
  
  private func applyLineHeight(to text: String, lineHeight: CGFloat) -> NSAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.minimumLineHeight = lineHeight
    paragraphStyle.maximumLineHeight = lineHeight
    paragraphStyle.lineBreakMode = .byTruncatingTail
    
    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: paragraphStyle,
      .font: Fonts.KR.B2,
      .foregroundColor: Colors.black.color
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
}

extension String {
  func toFormattedDate() -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let date = dateFormatter.date(from: self) else {
      return nil
    }
    dateFormatter.dateFormat = "yyyy년 M월 d일"
    return dateFormatter.string(from: date)
  }
}
