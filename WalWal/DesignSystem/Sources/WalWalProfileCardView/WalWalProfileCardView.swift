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
  
  private let profileContainer = UIView()
  private let profileImageView = UIImageView()
  
  private let infoContainer = UIView()
  private let nameLabel = CustomLabel(font: Fonts.KR.H6.B).then {
    $0.numberOfLines = 1
    $0.textColor = Colors.black.color
  }
  
  private let subDescriptionLabel = UILabel().then {
    $0.numberOfLines = 1
  }
  
  private let chipContainer = UIView()
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
    subDescription: String? = nil,
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
    self.subDescription = subDescription ?? ""
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
    
    containerView.flex.define { flex in
      flex.addItem()
        .direction(.row)
        .alignItems(.center)
        .justifyContent(.center)
        .paddingHorizontal(20)
        .height(100)
        .width(100%)
        .define { flex in
          flex.addItem(profileContainer).marginRight(10)
          flex.addItem(infoContainer).grow(1).shrink(1)
          flex.addItem(chipContainer).marginLeft(22)
        }
    }
    
    profileContainer.flex.define { flex in
      flex.addItem(profileImageView).size(54)
    }
    
    infoContainer.flex.define { flex in
      flex.addItem(nameLabel)
      flex.addItem(subDescriptionLabel).marginTop(2)
    }
    
    chipContainer.flex.define { flex in
      flex.addItem(actionChip)
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
    
    subDescriptionLabel.font = Fonts.KR.B1
    subDescriptionLabel.textColor = Colors.gray600.color
  }
  
  /// 프로필 정보 변경 메서드
  public func changeProfileInfo(
    nickname: String,
    image: UIImage?,
    raisePet: String,
    subDescription: String? = nil
  ) {
    nameLabel.text = nickname
    if let image = image {
      profileImageView.image = image
    } else {
      profileImageView.image = raisePet == "DOG" ? DefaultProfile.yellowDog.image : DefaultProfile.yellowCat.image
    }
    subDescriptionLabel.text = subDescription
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
