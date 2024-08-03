//
//  WalWalProfileCardViewDemoViewController.swift
//  DesignSystemDemoApp
//
//  Created by 조용인 on 8/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit

import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

final class WalWalProfileCardDemoViewController: UIViewController {
  
  // MARK: - UI
  
  private let rootView = UIView().then {
    $0.backgroundColor = ResourceKitAsset.Colors.white.color
  }
  
  private lazy var profileCard1 = WalWalProfileCardView(
    profileImage: ResourceKitAsset.Sample.calendarCellSample.image,
    name: "조조조",
    subDescription: "iOS Developer",
    chipStyle: .filled,
    chipTitle: "팔로우",
    selectedChipStyle: .outlined,
    selectedChipTitle: "팔로잉"
  )
  
  private lazy var profileCard2 = WalWalProfileCardView(
    profileImage: ResourceKitAsset.Sample.calendarCellSample.image,
    name: "용용용",
    subDescription: "WWWWWWWWWWWW",
    chipStyle: .tonal,
    chipTitle: "수정"
  )
  
  private lazy var profileCard3 = WalWalProfileCardView(
    profileImage: ResourceKitAsset.Sample.calendarCellSample.image,
    name: "인인인인인인인인인인인인인인",
    subDescription: "WWWWWWWWWWWWWWWWWWWW",
    chipStyle: .filled,
    chipTitle: "👍🏻",
    selectedChipStyle: .outlined,
    selectedChipTitle: "🔥"
  )
  
  private let statusLabel = UILabel().then {
    $0.textAlignment = .center
    $0.numberOfLines = 0
    $0.textColor = ResourceKitAsset.Colors.black.color
    $0.font = ResourceKitFontFamily.KR.B2
  }
  
  // MARK: - Properties
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureLayouts()
    bind()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootView.pin.all(view.pin.safeArea)
    rootView.flex.layout()
  }
  
  // MARK: - Methods
  
  private func configureLayouts() {
    view.addSubview(rootView)
    
    rootView.flex.marginVertical(20).define { flex in
      flex.addItem(profileCard1).marginBottom(20)
      flex.addItem(profileCard2).marginBottom(20)
      flex.addItem(profileCard3).marginBottom(20)
      flex.addItem(statusLabel).grow(1)
    }
  }
  
  private func bind() {
    let profileCards = [
      ("조조조", profileCard1),
      ("용용용", profileCard2),
      ("인인인", profileCard3)
    ]
    
    Observable.merge(
      profileCards.map { name, card in
        card.rx.chipTapped.map { "\(name)'s chip tapped" }
      }
    )
    .bind(to: statusLabel.rx.text)
    .disposed(by: disposeBag)
    
    profileCards.forEach { name, card in
      card.rx.isChipSelected
        .map { isSelected in
          let action = isSelected ? "selected" : "deselected"
          return "\(name)'s chip \(action)"
        }
        .bind(to: statusLabel.rx.text)
        .disposed(by: disposeBag)
    }
  }
}
