//
//  MissionStartView.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 8/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import FlexLayout
import PinLayout
import Then

final class MissionStartView: UIView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let todayMissionLabel = UILabel().then {
    $0.text = "오늘의 미션"
    $0.textColor = Colors.walwalOrange.color
    $0.font = Fonts.KR.H6.B
  }
  private let titleLabel = UILabel().then {
    $0.font = Fonts.KR.H2
    $0.textColor = Colors.black.color
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  private let missionImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  // MARK: - Initializers
  
  init(missionTitle: String, missionImage: UIImage) {
    super.init(frame: .zero)
    titleLabel.text = missionTitle
    missionImageView.image = missionImage /// 데이터 통신하면서 String 타입으로 수정 예정
    
    configureAttribute()
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  private func configureAttribute() {
    addSubview(rootContainer)
    
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
  }
  
  private func configureLayout() {
    rootContainer.flex
      .define {
        $0.addItem(todayMissionLabel)
          .alignSelf(.center)
        $0.addItem(titleLabel)
          .marginTop(14.adjusted)
          .marginHorizontal(20.adjusted)
        $0.addItem(missionImageView)
          .marginTop(14.adjusted)
          .marginHorizontal(0)
          .height(330.adjusted)
      }
  }
}
