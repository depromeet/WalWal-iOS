//
//  WalWalChipDemoViewController.swift
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

final class WalWalChipDemoViewController: UIViewController {
  
  // MARK: - UI
  
  private let rootView = UIView().then {
    $0.backgroundColor = ResourceKitAsset.Colors.white.color
  }
  
  private let filledChip = WalWalChip(text: "Filled", style: .filled)
  
  private let outlinedChip = WalWalChip(text: "Outlined", style: .outlined)
  
  private let tonalChip = WalWalChip(text: "Tonal", style: .tonal)
  
  private let interactiveChip = WalWalChip(
    text: "뾰로롱",
    selectedText: "선택됨",
    style: .filled,
    selectedStyle: .tonal,
    size: CGSize(width: 120, height: 72),
    font: ResourceKitFontFamily.KR.H2
  )
  
  private let statusLabel = UILabel().then {
    $0.textAlignment = .center
    $0.numberOfLines = 0
    $0.textColor = ResourceKitAsset.Colors.black.color
    $0.font = ResourceKitFontFamily.KR.B2
  }
  
  // MARK: - Properties
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureLayouts()
    bind()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootView.pin
      .all(view.pin.safeArea)
    rootView.flex
      .layout()
  }
  
  // MARK: - Methods
  
  private func configureLayouts() {
    view.addSubview(rootView)
    
    rootView.flex
      .padding(20)
      .direction(.column)
      .define { flex in
        flex.addItem()
          .direction(.row)
          .justifyContent(.spaceEvenly)
          .define { flex in
            flex.addItem(filledChip)
            flex.addItem(outlinedChip)
            flex.addItem(tonalChip)
          }
        
        flex.addItem(interactiveChip)
          .marginTop(20)
          .alignSelf(.center)
        
        flex.addItem(statusLabel)
          .marginTop(20)
          .height(100%)
          .width(100%)
      }
  }
  
  private func bind() {
    
    filledChip.rx.tapped
      .map { "Filled Chip Tapped" }
      .bind(to: statusLabel.rx.text)
      .disposed(by: disposeBag)
    
    outlinedChip.rx.tapped
      .map { "Outlined Chip Tapped" }
      .bind(to: statusLabel.rx.text)
      .disposed(by: disposeBag)
    
    tonalChip.rx.tapped
      .map { "Tonal Chip Tapped" }
      .bind(to: statusLabel.rx.text)
      .disposed(by: disposeBag)
    
    interactiveChip.rx.tapped
      .scan(0) { (count, _) in count + 1 }
      .map { "Tapped \($0) times" }
      .bind(to: statusLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
