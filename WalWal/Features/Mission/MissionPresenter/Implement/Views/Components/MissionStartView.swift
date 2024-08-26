//
//  MissionStartView.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 8/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import DesignSystem

import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

final class MissionStartView: UIView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let titleContainer = UIView()
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
  
  init(
    missionTitle: String,
    missionImage: UIImage
  ) {
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
      .direction(.column)
      .define { flex in
        flex.addItem(titleContainer)
          .direction(.column)
          .marginHorizontal(20)
          .define { flex in
            flex.addItem(todayMissionLabel)
              .alignSelf(.center)
            flex.addItem(titleLabel)
              .marginTop(4.adjusted)
          }
        flex.addItem(missionImageView)
          .marginTop(24.adjusted)
          .width(100%)
          .height(330.adjusted)
      }
  }
  
  func configureStartView(title: String, missionImageURL: String) {
    self.titleLabel.text = title
    self.missionImageView.kf.setImage(with: URL(string: missionImageURL))
  }
}

extension Reactive where Base: MissionStartView {
  var configureStartView: Binder<(title: String, missionImageURL: String)> {
    return Binder(base) { view, data in
      view.configureStartView(title: data.title, missionImageURL: data.missionImageURL)
    }
  }
}
