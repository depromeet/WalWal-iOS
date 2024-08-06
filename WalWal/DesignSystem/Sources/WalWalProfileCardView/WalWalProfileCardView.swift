//
//  WalWalProfileCardView.swift
//  DesignSystem
//
//  Created by 조용인 on 8/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import RxSwift
import RxCocoa
import FlexLayout
import PinLayout
import Then

public final class WalWalProfileCardView: UIView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let containerView = UIView()
  
  private let profileImageView = UIImageView()
  
  private let nameLabel = UILabel().then {
    $0.numberOfLines = 1
  }
  
  private let subDescriptionLabel = UILabel().then {
    $0.numberOfLines = 1
  }
  
  fileprivate let actionChip: WalWalChip
  
  // MARK: - Properties
  
  private let profileImage: UIImage
  private let name: String
  private let subDescription: String
  private let chipStyle: WalWalChip.ChipStyle
  private let selectedChipStyle: WalWalChip.ChipStyle
  private let chipTitle: String?
  private let selectedChipTitle: String?
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializars
  
  
  /// WalWalProfileCardView를 초기화합니다.
  /// - Parameters:
  ///   - profileImage: 프로필 이미지
  ///   - name: 이름
  ///   - subDescription: 설명
  ///   - chipStyle: 초기 ChipStyle
  ///   - chipTitle: 초기 ChipTitle
  ///   - selectedChipStyle: 선택되었을 때의 ChipStyle (default = chipStyle)
  ///   - selectedChipTitle: 선택되었을 때의 ChipTitle (default = chipTitle)
  public init(
    profileImage: UIImage,
    name: String,
    subDescription: String,
    chipStyle: WalWalChip.ChipStyle,
    chipTitle: String? = nil,
    selectedChipStyle: WalWalChip.ChipStyle = WalWalChip.ChipStyle.none,
    selectedChipTitle: String? = nil
  ) {
    self.chipStyle = chipStyle
    self.selectedChipStyle = selectedChipStyle
    self.chipTitle = chipTitle
    self.selectedChipTitle = selectedChipTitle
    self.profileImage = profileImage
    self.name = name
    self.subDescription = subDescription
    self.actionChip = WalWalChip(
      text: chipTitle,
      selectedText: selectedChipTitle,
      style: chipStyle,
      selectedStyle: selectedChipStyle
    )
    super.init(frame: .zero)
    configureLayout()
    configureAttributes()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycles
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin
      .all()
    containerView.flex
      .layout()
  }
  
  // MARK: - Methods
  
  private func configureLayout() {
    addSubview(containerView)
    
    containerView.flex
      .define { flex in
        flex.addItem()
          .direction(.row)
          .alignItems(.center)
          .justifyContent(.center)
          .paddingHorizontal(20)
          .height(100)
          .width(100%)
          .define { flex in
            flex.addItem(profileImageView)
              .size(54)
              .marginRight(8)
            flex.addItem()
              .grow(1)
              .shrink(1)
              .define { flex in
                flex.addItem(nameLabel)
                flex.addItem(subDescriptionLabel)
                  .marginTop(2)
              }
            flex.addItem(actionChip)
              .marginLeft(24)
          }
      }
  }
  
  public func configureAttributes() {
    profileImageView.image = profileImage
    nameLabel.text = name
    subDescriptionLabel.text = subDescription
    
    backgroundColor = Colors.white.color
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    layer.cornerRadius = 20
    layer.borderWidth = 1
    layer.borderColor = Colors.gray150.color.cgColor
    
    profileImageView.layer.cornerRadius = 27
    profileImageView.clipsToBounds = true
    profileImageView.contentMode = .scaleAspectFill
    
    nameLabel.font = Fonts.KR.H6.B
    nameLabel.textColor = Colors.black.color
    
    subDescriptionLabel.font = Fonts.KR.B1
    subDescriptionLabel.textColor = Colors.gray600.color
  }
}

// MARK: - Reactive Extension
extension Reactive where Base: WalWalProfileCardView {
  
  public var chipTapped: ControlEvent<Void> {
    return base.actionChip.rx.tapped
  }
  
  public var isChipSelected: Observable<Bool> {
    return base.actionChip.rx.isTapped
  }
}
