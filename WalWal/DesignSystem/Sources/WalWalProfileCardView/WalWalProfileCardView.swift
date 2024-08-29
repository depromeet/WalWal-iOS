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
  private let profileInfoContainer = UIView()
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
  
  private let missionCountView = UIView().then {
    $0.backgroundColor = Colors.gray150.color
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
  }
  private let missionIconImageView = UIImageView().then {
    $0.image = Images.missionStartIcon.image
  }
  private lazy var missionCountLabel = UILabel().then {
    $0.font = Fonts.KR.B1
    $0.textColor = Colors.black.color
    
    $0.text = "반려동물과 \(missionCount)개 미션을 수행하고 있어요!"
    $0.asColor(targetString: "\(missionCount)개", color: Colors.walwalOrange.color)
  }
  
  
  // MARK: - Properties
  
  private let profileImage: UIImage
  private let name: String
  private var missionCount = 0
  private let subDescription: String
  private let chipStyle: WalWalChip.ChipStyle
  private let selectedChipStyle: WalWalChip.ChipStyle
  private let chipTitle: String?
  private let selectedChipTitle: String?
  private let isOther: Bool
  
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
    selectedChipTitle: String? = nil,
    isOther: Bool = false,
    missionCount: Int? = nil
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
    self.missionCount = missionCount ?? 0
    self.isOther = isOther
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
    let height = isOther ? 200 : 100
    missionCountView.flex.isIncludedInLayout(isOther)
    
    containerView.flex.define { flex in
      flex.addItem()
        .alignItems(.center)
        .justifyContent(.center)
        .marginHorizontal(20)
        .height(height.adjustedHeight)
        .define { flex in
          flex.addItem(profileInfoContainer)
            .marginBottom(21.adjustedHeight)
          flex.addItem(missionCountView)
            .width(100%)
        }
    }
    
    profileInfoContainer.flex.define { flex in
      flex.addItem()
        .direction(.row)
        .justifyContent(.center)
        .alignItems(.center)
        .width(100%)
        .define { flex in
          flex.addItem(profileContainer).marginRight(10)
          flex.addItem(infoContainer).width(190.adjusted)
          flex.addItem(chipContainer).marginLeft(22)
            .height(28)
            .width(64)
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
        .width(100%)
        .height(100%)
    }
    
    missionCountView.flex
      .direction(.row)
      .alignItems(.center)
      .justifyContent(.center)
      .height(44.adjusted)
      .define { flex in
        flex.addItem(missionIconImageView)
        flex.addItem(missionCountLabel)
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
    missionCount: Int = 0,
    subDescription: String? = nil
  ) {
    nameLabel.text = nickname
    if let image = image {
      profileImageView.image = image
    } else {
      profileImageView.image = raisePet == "DOG" ? DefaultProfile.yellowDog.image : DefaultProfile.yellowCat.image
    }
    subDescriptionLabel.text = subDescription
    
    missionCountLabel.text = "반려동물과 \(missionCount)개 미션을 수행하고 있어요!"
    missionCountLabel.asColor(
      targetString: "\(missionCount)",
      color: Colors.walwalOrange.color
    )
    
    missionCountLabel.flex
      .markDirty()
    
    missionCountView.flex
      .markDirty()
    
    containerView.flex
      .layout()
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
