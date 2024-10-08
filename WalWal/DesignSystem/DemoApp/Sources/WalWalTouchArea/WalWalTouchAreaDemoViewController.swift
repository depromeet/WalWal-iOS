//
//  WalWalTouchAreaDemoViewController.swift
//  DesignSystem
//
//  Created by 조용인 on 7/29/24.
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

final class WalWalTouchAreaDemoViewController: UIViewController {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let rootView = UIView().then {
    $0.backgroundColor = Colors.walwalOrange.color
  }
  
  private let touchArea1 = WalWalTouchArea(size: 40)
  
  private let touchArea2 = WalWalTouchArea(size: 40)
  
  private let touchArea3 = WalWalTouchArea(size: 40)
  
  private let touchArea4 = WalWalTouchArea(
    image: Images.calendarL.image,
    size: 40
  )
  
  private let statusLabel = UILabel().then {
    $0.textAlignment = .center
    $0.numberOfLines = 0
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
    configureTouchAreas()
    configureLayouts()
    bind()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootView.pin.all(view.pin.safeArea)
    rootView.flex.layout()
  }
  
  // MARK: - Methods
  
  private func configureTouchAreas() {
    touchArea1.setImage(Images.calendarL.image, for: .normal)
    touchArea1.setImage(Images.cameraL.image, for: .selected)
    
    touchArea2.setImage(Images.swapL.image, for: .normal)
    touchArea2.setImage(Images.settingL.image, for: .selected)
    
    touchArea3.setImage(Images.calendarL.image, for: .normal)
    touchArea3.setImage(Images.backL.image, for: .selected)
  }
  
  private func configureLayouts() {
    view.addSubview(rootView)
    
    rootView.flex
      .justifyContent(.center)
      .define { flex in
        flex.addItem()
          .direction(.row)
          .justifyContent(.spaceEvenly)
          .define { flex in
            flex.addItem(touchArea1)
            flex.addItem(touchArea2)
            flex.addItem(touchArea3)
            flex.addItem(touchArea4)
          }
        flex.addItem(statusLabel)
          .marginTop(20)
      }
  }
  
  private func bind() {
    Observable.combineLatest(touchArea1.state, touchArea2.state, touchArea3.state, touchArea4.state)
      .map { state1, state2, state3, state4 -> String in
        return """
                TouchArea 1: \(state1)
                
                TouchArea 2: \(state2)
                
                TouchArea 3: \(state3)
                
                TouchArea 4: \(state4)
                """
      }
      .bind(to: statusLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
