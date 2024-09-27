//
//  RecordCarouselCell.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 9/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import DesignSystem
import RecordsDomain

import Then
import PinLayout
import FlexLayout
import RxSwift

final class RecordCarouselCell: UICollectionViewCell, ReusableView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily.KR
  
  var disposeBag = DisposeBag()
  
  // MARK: - UI
  
  /// 미션 기록 보기
  private let rootContainer = UIView().then {
    $0.backgroundColor = .red
    $0.layer.borderColor = Colors.white.color.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 30.adjusted
    $0.layer.shadowColor = UIColor(hex: 0xCCCCCC, alpha: 0.4).cgColor
    $0.layer.shadowRadius = 15
    $0.layer.shadowOffset = CGSize(width: 0, height: 0)
  }
  private let recordContainer = UIView()
  let swapButton = UIButton().then {
    $0.setImage(Images.swapL.image, for: .normal)
    $0.backgroundColor = .white
  }
  private let recordimageView = UIImageView()
  
  private let dateChipView = UIView()
  private let dateLabel = UILabel()
  
  private let contentsLabel = UILabel().then {
    $0.font = Fonts.H7.SB
    $0.textColor = Colors.gray600.color
  }
  /// 미션 정보 보기
  private let todayMission = UILabel().then {
    $0.text = "오늘의 미션"
    $0.font = Fonts.H7.B
    $0.textColor = Colors.walwalOrange.color
  }
  private let missionTitleLabel = UILabel().then {
    $0.font = Fonts.H4
    $0.textColor = Colors.black.color
  }
  private let missionImageView = UIImageView()
  
  // MARK: - Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  // MARK: - Layout
  
  private func configureUI() {
    configureAttribute()
    configureLayout()
  }
  
  private func configureAttribute() {
    addSubview(rootContainer)
    
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
  }
  
  private func configureLayout() {
    rootContainer.flex
      .define { flex in
        flex.addItem(recordimageView)
          .size(255.adjusted)
        flex.addItem(contentsLabel)
      }
  }
  
  private func bind() {
    
  }
  
  func configureCell(record: RecordList) {
    // 이미지 바인딩 필요
    self.contentsLabel.text = record.recordContent
    self.missionTitleLabel.text = record.missionTitle
    self.missionImageView.kf.setImage(with: URL(string: record.missionIllustrationURL))
    self.recordimageView.kf.setImage(with: URL(string: record.recordImageURL))
  }
  
}
