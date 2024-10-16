//
//  FCMCollectionViewCell.swift
//  FCMPresenterImp
//
//  Created by Jiyeon on 8/28/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import FCMPresenter
import DesignSystem
import ResourceKit
import FCMDomain
import Utility

import ReactorKit
import Then
import FlexLayout
import PinLayout

final class FCMCollectionViewCell: UICollectionViewCell, ReusableView, View {
  typealias Reactor = FCMCellReactor
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias FontEN = ResourceKitFontFamily.EN
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let contentContainer = UIView()
  
  private let iconContainer = UIView().then {
    $0.backgroundColor = .clear
  }
  private let iconImageView = UIImageView().then {
    $0.backgroundColor = Colors.gray150.color
    $0.contentMode = .scaleAspectFill
  }
  private let badgeImageView = UIImageView().then {
    $0.backgroundColor = .clear
  }
  
  private let titleLabel = CustomLabel(font: FontKR.B2).then {
    $0.textColor = Colors.walwalOrange.color
  }
  
  private let messageLabel = CustomLabel(font: FontKR.B1).then {
    $0.textColor = Colors.black.color
  }
  private let dateLabel = CustomLabel(font: FontEN.Caption).then {
    $0.textColor = Colors.gray500.color
  }
  
  // MARK: - Properties
  
  public var changeIsReadValue = PublishSubject<Bool>()
  var disposeBag = DisposeBag()
  
  var isRead: Bool = false {
    didSet {
      contentView.backgroundColor = self.isRead ? Colors.gray150.color : Colors.gray100.color
    }
  }
  
  // MARK: - Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configAttribute()
    configLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  override func prepareForReuse() {
    super.prepareForReuse()
    iconImageView.image = nil
    badgeImageView.isHidden = true
    titleLabel.text = nil
    messageLabel.text = nil
    dateLabel.text = nil
    disposeBag = DisposeBag()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
    
    badgeImageView.pin
      .bottomRight()
      .size(20.adjusted)
    iconImageView.pin
      .topLeft()
      .size(54.adjusted)
    
    iconImageView.layer.cornerRadius = iconImageView.frame.width/2
    iconImageView.clipsToBounds = true
  }
  
  private func configAttribute() {
    contentView.backgroundColor = Colors.gray100.color
    contentView.addSubview(rootContainer)
    [iconImageView, badgeImageView].forEach {
      iconContainer.addSubview($0)
    }
  }
  
  private func configLayout() {
    rootContainer.flex
      .direction(.row)
      .justifyContent(.start)
      .alignItems(.center)
      .marginHorizontal(20)
      .define {
        $0.addItem(iconContainer)
          .size(56.adjusted)
        $0.addItem(contentContainer)
          .grow(1)
          .shrink(1)
          .marginLeft(10)
      }
    
    contentContainer.flex
      .justifyContent(.start)
      .alignItems(.start)
      .define {
        $0.addItem()
          .direction(.row)
          .justifyContent(.spaceBetween)
          .width(100%)
          .define {
            $0.addItem(titleLabel)
            $0.addItem()
            $0.addItem(dateLabel)
          }
        $0.addItem(messageLabel)
          .marginTop(2)
      }
    
  }
  
  // MARK: - Methods
  
  func bind(reactor: Reactor) {
    let items = reactor.currentState
    configureCell(items: items)
    
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  private func bindAction(reactor: Reactor) {
    changeIsReadValue
      .filter { _ in !reactor.currentState.isRead }
      .map { Reactor.Action.changeIsReadValue(value: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  private func bindState(reactor: Reactor) {
    reactor.state
      .map { $0.isRead }
      .asDriver(onErrorJustReturn: false)
      .filter { $0 }
      .drive(with: self) { owner, isRead in
        owner.isRead = isRead
      }
      .disposed(by: disposeBag)
  }
  
  private func configureCell(items: FCMItemModel) {
    let tintColor: UIColor = items.type.tintColor
    let image = items.type == .mission ? Images.missionNoti.image : items.image
    let badgeImage = items.type.badgeImage
    
    titleLabel.textColor = tintColor
    titleLabel.text = items.title
    
    messageLabel.text = items.message
    messageLabel.configAttributedText(color: tintColor)
    
    dateLabel.text = items.createdAt.formattedRelativeDate(
      format: .fullISO8601,
      to: .yearMonthDayDots
    )
    dateLabel.changeFont(to: FontKR.Caption)
    
    iconImageView.image = image
    badgeImageView.isHidden = items.type == .mission
    badgeImageView.image = badgeImage
    
    isRead = items.isRead
    
    titleLabel.flex.markDirty()
    dateLabel.flex.markDirty()
    messageLabel.flex.markDirty()
    
    layoutIfNeeded()
  }
  
}

fileprivate extension UILabel {
  func configAttributedText(color: UIColor) {
    guard let fullText = self.text else { return }
    
    let patterns = ["\\d+시간", "\\d+개"]
    let attributedString = NSMutableAttributedString(string: fullText)
    for pattern in patterns {
      if let regex = try? NSRegularExpression(pattern: pattern) {
        let matches = regex.matches(in: fullText, range: NSRange(location: 0, length: fullText.count))
        
        for match in matches {
          attributedString.addAttribute(.foregroundColor, value: color, range: match.range)
        }
      }
    }
    self.attributedText = attributedString
  }
  
  func changeFont(to font: UIFont) {
    guard let text = self.text else { return }
    
    let attributedString = NSMutableAttributedString(string: text)
    
    let pattern = "[가-힣]"
    
    if let regex = try? NSRegularExpression(pattern: pattern) {
      let matches = regex.matches(in: text, range: NSRange(location: 0, length: text.count))
      
      for match in matches {
        attributedString.addAttribute(.font, value: font, range: match.range)
      }
    }
    
    self.attributedText = attributedString
  }
}

fileprivate extension FCMTypes {
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  
  var tintColor: UIColor {
    switch self {
    case .mission:
      return Colors.walwalOrange.color
    case .boost:
      return UIColor(hex: 0xFF6668)
    case .comment, .recomment:
      return Colors.blue.color
    }
  }
  
  var badgeImage: UIImage? {
    switch self {
    case .mission:
      return nil
    case .boost:
      return Images.boostNoti.image
    case .comment, .recomment:
      return Images.commentNoti.image
    }
  }
}
