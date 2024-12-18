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
  
  private typealias Assets = ResourceKitAsset.Assets
  private typealias Sample = ResourceKitAsset.Sample
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
  
  private let headerView = UIView()
  private let profileHeaderView = UIView()
  private let profileInfoView = UIView()
  private let imageContentView = UIView()
  private let feedContentView = UIView()
  private let boostLabelView = UIView()
  private let comentLabelView = UIView()
  private let reactionView = UIView()
  
  private let profileImageView = UIImageView().then {
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
  
  public let feedMenuButton = UIButton().then {
    $0.setImage(Images.menu.image, for: .normal)
  }
  
  private let missionImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private let boostIconImageView = UIImageView().then {
    $0.image = Assets.fire.image
    $0.contentMode = .scaleAspectFit
  }
  
  private let commentIconImageView = UIImageView().then {
    $0.image = Assets.messageCircle.image
    $0.contentMode = .scaleAspectFit
  }
  
  let contentLabel = CustomLabel(font: Fonts.KR.B3).then {
    $0.textColor = Colors.black.color
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 2
    $0.lineBreakStrategy = .hangulWordPriority
  }
  
  private let boostCountLabel = CustomLabel(font: Fonts.EN.H2).then {
    $0.textColor = Colors.gray500.color
  }
  
  private let commentCountLabel = CustomLabel(font: Fonts.EN.H2).then {
    $0.textColor = Colors.gray500.color
  }
  
  private let missionDateLabel = CustomLabel(font: Fonts.KR.B2).then {
    $0.textColor = Colors.gray500.color
  }
  
  // MARK: - Property
  
  var feedData: WalWalFeedModel?
  public private(set) var contents = ""
  var disposeBag = DisposeBag()
  
  private let profileTappedSubject = PublishSubject<WalWalFeedModel>()
  public var profileTapped: Observable<WalWalFeedModel> {
    return profileTappedSubject.asObservable()
  }
  private let menuButtonTapEvent = PublishSubject<Int>()
  public var menuButtonTapped: Observable<Int> {
    return menuButtonTapEvent.asObservable()
  }
  
  private let commentButtonTapEvent = PublishSubject<(recordId: Int, writerNickname: String)>()
  public var commentButtonTapped: Observable<(recordId: Int, writerNickname: String)> {
    return commentButtonTapEvent.asObservable()
  }
  
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
    
    profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
  }
  
  // MARK: - Methods
  
  func configureFeed(feedData: WalWalFeedModel, isBoost: Bool = false, isAlreadyExpanded: Bool = false) {
    
    userNickNameLabel.text = feedData.nickname
    missionLabel.text = sanitizeContent(feedData.missionTitle)
    profileImageView.image = feedData.profileImage
    missionImageView.image = feedData.missionImage
    commentCountLabel.text = "\(feedData.commentCount)" 
    boostCountLabel.text = "\(feedData.boostCount)"
    let isBoostImage = isBoost ? Assets.fire.image.withTintColor(Colors.walwalOrange.color) : Assets.fire.image
    let isBoostColor = isBoost ? Colors.walwalOrange.color : Colors.gray500.color
    boostIconImageView.image = isBoostImage
    boostCountLabel.textColor = isBoostColor
    contents = sanitizeContent(feedData.contents)
    
    contentLabel.text = contents
    missionDateLabel.attributedText = setupDateLabel(to: feedData.date)
    self.feedData = feedData
    self.isExpanded = isAlreadyExpanded

    if isExpanded {
        contentLabel.text = contents
    } else {
        contentLabel.text = contents
        DispatchQueue.main.async {
            if self.contents.lineNumber(forWidth: self.contentLabel.width, font: Fonts.KR.B3) > 2 {
                self.contentLabel.configureSpacing(text: self.contents, font: Fonts.KR.B3)
                self.contentLabel.addTrailing(with: "...", moreText: " 더 보기", moreTextFont: Fonts.KR.B3, moreTextColor: Colors.gray500.color)
            }
        }
    }

    
    commentCountLabel.flex.markDirty()
    boostCountLabel.flex.markDirty()
    
    missionDateLabel.flex
      .markDirty()
    
    boostLabelView.flex
      .markDirty()
    
    comentLabelView.flex
      .markDirty()
    
    feedContentView.flex
      .markDirty()
    
    reactionView.flex
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
    
    [missionImageView, reactionView].forEach {
      feedContentView.addSubview($0)
    }
    
  }
  
  private func setLayouts() {
    
    containerView.flex
      .define {
        $0.addItem(headerView)
          .marginHorizontal(16.adjusted)
          .marginVertical(15.adjustedWidth)
        $0.addItem(imageContentView)
        $0.addItem(reactionView)
          .height(24.adjustedWidth)
          .marginTop(12.adjustedHeight)
          .marginHorizontal(12.adjusted)
        $0.addItem(feedContentView)
          .minHeight(16.adjustedWidth)
          .marginHorizontal(16.adjusted)
          .marginTop(9.adjusted)
          .marginBottom(9.adjusted)
        $0.addItem(missionDateLabel)
          .marginHorizontal(16.adjusted)
          .marginBottom(20.adjustedWidth)
      }
    
    headerView.flex
      .direction(.row)
      .justifyContent(.spaceBetween)
      .alignItems(.center)
      .define {
        $0.addItem(profileHeaderView)
          .grow(1)
        $0.addItem(feedMenuButton)
          .size(24)
      }
    
    profileHeaderView.flex
      .direction(.row)
      .alignItems(.center)
      .define {
        $0.addItem(profileImageView)
          .size(40.adjusted)
        $0.addItem(profileInfoView)
          .grow(1)
          .marginLeft(10.adjusted)
      }
    
    profileInfoView.flex
      .define {
        $0.addItem(userNickNameLabel)
        $0.addItem(missionLabel)
          .marginTop(2.adjustedWidth)
          .grow(1)
      }
    
    imageContentView.flex
      .width(100%)
      .define({
        $0.addItem(missionImageView)
          .height(343.adjustedWidth)
        
      })
    
    feedContentView.flex
      .direction(.column)
      .justifyContent(.center)
      .define {
        $0.addItem(contentLabel)
      }
    
    reactionView.flex
      .direction(.row)
      .width(100%)
      .define{ flex in
        flex.addItem(comentLabelView)
          .marginRight(8.adjusted)
        flex.addItem(boostLabelView)
      }
    
    comentLabelView.flex.direction(.row)
      .define { flex in
        flex.addItem(commentIconImageView)
          .marginRight(1.adjusted)
        flex.addItem(commentCountLabel)
      }
    boostLabelView.flex.direction(.row)
      .define { flex in
        flex.addItem(boostIconImageView)
          .marginRight(1.adjusted)
        flex.addItem(boostCountLabel)
      }
  }
  
  func toggleContent() {
    contentLabel.numberOfLines = 3
    contentLabel.text = contents
    setNeedsLayout()
  }
  
  func clearImageView() {
    self.missionImageView.image = nil
    self.profileImageView.image = nil
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
      .font: Fonts.KR.B3,
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
  
  // MARK: - Binding
  
    
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
    
    profileHeaderView.rx.tapped
      .compactMap { [weak self] in
        return self?.feedData
      }
      .bind(to: profileTappedSubject)
      .disposed(by: disposeBag)
    
    feedMenuButton.rx.tap
      .withUnretained(self)
      .compactMap { owner, _ in
        owner.feedData?.recordId
      }
      .bind(to: menuButtonTapEvent)
      .disposed(by: disposeBag)
    
    comentLabelView.rx.tapped
      .withUnretained(self)
      .compactMap { owner, _  in return owner.feedData }
      .map{ ($0.recordId, $0.nickname) }
      .bind(to: commentButtonTapEvent)
      .disposed(by: disposeBag)
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
