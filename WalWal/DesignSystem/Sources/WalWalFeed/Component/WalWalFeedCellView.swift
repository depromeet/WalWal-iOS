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

public final class WalWalFeedCellView: UIView {
  
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
  private let imageContentView = UIView()
  private let feedContentView = UIView()
  private let boostLabelView = UIView()
  
  private let profileImageView = UIImageView().then {
    $0.layer.cornerRadius = 20
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.isUserInteractionEnabled = false
  }
  
  private let userNickNameLabel = CustomLabel(font: Fonts.KR.H7.B).then {
    $0.textColor = Colors.black.color
    $0.isUserInteractionEnabled = false
  }
  
  private let missionLabel = CustomLabel(font: Fonts.KR.B2).then {
    $0.textColor = Colors.gray700.color
    $0.isUserInteractionEnabled = false
  }
  
  private let missionImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private let boostIconImageView = UIImageView().then {
    $0.image = Images.fireDef.image
  }
  
  let contentLabel = CustomLabel(font: Fonts.KR.B2).then {
    $0.textColor = Colors.black.color
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 2
    $0.lineBreakStrategy = .hangulWordPriority
  }
  
  private let boostCountLabel = CustomLabel(font: Fonts.EN.B2).then {
    $0.textColor = Colors.gray500.color
  }
  
  private let boostLabel = CustomLabel(text: "부스터", font: Fonts.KR.B2).then {
    $0.textColor = Colors.gray500.color
  }
  
  private let missionDateLabel = CustomLabel(font: Fonts.KR.B2).then {
    $0.textColor = Colors.gray500.color
  }
  
  var maxLength = 55
  public private(set) var contents = ""
  private let disposeBag = DisposeBag()
  private let moreTappedSubject = PublishSubject<Bool>()
  
  // MARK: - Property
  var feedData: WalWalFeedModel?
  
  private let profileTappedSubject = PublishSubject<WalWalFeedModel>()
  public var profileTapped: Observable<WalWalFeedModel> {
    return profileTappedSubject.asObservable()
  }
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
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    missionDateLabel.flex
      .markDirty()
    
    boostLabelView.flex
      .markDirty()
    
    missionImageView.flex
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
  
  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
      let view = super.hitTest(point, with: event)
      return view === self ? nil : view
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
    missionLabel.text = sanitizeContent(feedData.missionTitle)
    profileImageView.image = feedData.profileImage
    missionImageView.image = feedData.missionImage
    boostCountLabel.text = "\(feedData.boostCount)"
    let isBoostImage = isBoost ? ResourceKitAsset.Sample.fireActive.image : ResourceKitAsset.Sample.fireDef.image
    let isBoostColor = isBoost ? Colors.walwalOrange.color : Colors.gray500.color
    boostIconImageView.image = isBoostImage
    boostCountLabel.textColor = isBoostColor
    boostLabel.textColor = isBoostColor
    contents = sanitizeContent(feedData.contents)
    contentLabel.text = contents
    missionDateLabel.attributedText = setupDateLabel(to: feedData.date)
    
    /// 부스트 애니메이션 시 이미 열려 있었으면 더보기 X
    if !isAlreadyExpanded  {
      if contents.count > maxLength {
        DispatchQueue.main.async {
          self.contentLabel.configureSpacing(text: self.contentLabel.text, font: Fonts.KR.B2)
          self.contentLabel.addTrailing(with: "...", moreText: "더 보기", moreTextFont: Fonts.KR.B2, moreTextColor: Colors.gray500.color)
        }
      }
    }
    
    boostCountLabel.flex
      .markDirty()
    
    missionDateLabel.flex
      .markDirty()
    
    boostLabelView.flex
      .markDirty()
    
    feedContentView.flex
      .markDirty()
    
    containerView.flex
      .markDirty()
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
    
    containerView.flex
      .define {
        $0.addItem(profileHeaderView)
          .marginHorizontal(16.adjusted)
          .marginVertical(15.adjusted)
        $0.addItem(imageContentView)
        $0.addItem(feedContentView)
          .minHeight(16.adjusted)
          .marginHorizontal(16.adjusted)
          .marginTop(14.adjusted)
        $0.addItem(boostLabelView)
          .marginTop(8.adjusted)
          .marginHorizontal(16.adjusted)
          .marginBottom(20.adjusted)
      }
    
    profileHeaderView.flex
      .direction(.row)
      .alignItems(.center)
      .width(100%)
      .define {
        $0.addItem(profileImageView)
          .size(40.adjusted)
        $0.addItem(profileInfoView)
          .marginLeft(10.adjusted)
      }
    
    profileInfoView.flex
      .width(100%)
      .define {
        $0.addItem(userNickNameLabel)
          .marginBottom(2.adjusted)
        $0.addItem(missionLabel)
          .grow(1)
      }
    
    imageContentView.flex
      .width(100%)
      .define({
        $0.addItem(missionImageView)
          .height(343.adjusted)
        
      })
    
    feedContentView.flex
      .width(100%)
      .direction(.column)
      .justifyContent(.center)
      .define {
        $0.addItem(contentLabel)
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
    return content.replacingOccurrences(of: "\n", with: " ")
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
  
  private func setupDateLabel(to text: String) -> NSAttributedString {
    
    let missionDate = text.toFormattedDate() ?? text
    let attributedString = NSMutableAttributedString(string: missionDate)
    
    let numberFont = Fonts.EN.Caption
    let defaultFont = Fonts.KR.B2
    
    attributedString.addAttribute(.font, value: defaultFont, range: NSRange(location: 0, length: missionDate.count))
    
    let numberPattern = "[0-9]"
    if let regex = try? NSRegularExpression(pattern: numberPattern, options: []) {
      let matches = regex.matches(in: missionDate, options: [], range: NSRange(location: 0, length: missionDate.count))
      for match in matches {
        attributedString.addAttribute(.font, value: numberFont, range: match.range)
      }
    }
    
    return attributedString
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
