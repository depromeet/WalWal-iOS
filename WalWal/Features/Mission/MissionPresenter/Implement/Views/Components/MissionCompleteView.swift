//
//  MissionCompleteView.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 8/22/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import Utility
import ResourceKit

import Then
import FlexLayout
import PinLayout

final class MissionCompleteView: UIView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  
  private let recordImageView = UIImageView().then {
    $0.image = ResourceKitAsset.Sample.feedSample.image
    $0.contentMode = .scaleAspectFill
    $0.layer.borderColor = Colors.walwalOrange.color.cgColor
    $0.layer.borderWidth = 6
    
    $0.layer.cornerRadius = 130.adjusted
    
    $0.clipsToBounds = true
  }
  private let SucessIconImageView = UIImageView().then {
    $0.image = Images.succes.image
  }
  private let missionCompletedLabel = UILabel().then {
    $0.text = "소중한 추억을\n쌓아가고 있어요!"
    $0.font = Fonts.KR.H2
    $0.textColor = Colors.black.color
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  
  private let guideLabel = UILabel().then {
    $0.text = "미션 기록에서 그 동안 쌓은 추억을 확인해보세요."
    $0.textAlignment = .center
    $0.font = Fonts.KR.H7.M
    $0.textColor = Colors.gray700.color.withAlphaComponent(0.5)
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    configureAttribute()
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
      .define {
        $0.addItem(recordImageView)
          .marginTop(10.adjusted)
          .size(260.adjusted)
          .alignSelf(.center)
        $0.addItem(SucessIconImageView)
          .alignSelf(.center)
          .size(.init(width: 54.adjusted, height: 56.adjusted))
          .marginTop(-30.adjusted)
        $0.addItem(missionCompletedLabel)
          .marginHorizontal(20.adjusted)
          .marginTop(24.adjusted)
        $0.addItem(guideLabel)
          .marginHorizontal(20.adjusted)
          .marginTop(4.adjusted)
          .marginBottom(35.adjusted)
      }
  }
  
  func configureStartView(recordImageURL: String) {
    self.recordImageView.kf.setImage(with: URL(string: recordImageURL))
  }
  
}
