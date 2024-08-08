//
//  WalWalButtonDemoViewController.swift
//  DesignSystemDemoApp
//
//  Created by 조용인 on 8/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import DesignSystem

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout


public final class WalWalButtonDemoViewController: UIViewController {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  private let containerView = UIView()
  
  let firstButton = WalWalButton(
    type: .icon,
    title: "다음",
    titleColor: Colors.white.color,
    backgroundColor: Colors.walwalOrange.color,
    image: Images.watchS.image
  )
  
  let secondButton = WalWalButton(
    type: .normal,
    title: "이미지 없음",
    titleColor: Colors.white.color,
    backgroundColor: Colors.gray500.color
  )
  
  let thirdButton = WalWalButton(
    type: .icon,
    title: "😵",
    titleColor: Colors.black.color,
    backgroundColor: Colors.white.color,
    image: Images.cameraS.image.withTintColor(Colors.blue.color)
  )
  
  let forthButton = WalWalButton(
    type: .normal,
    title: "다음",
    backgroundColor: Colors.blue.color,
    disabledTitle: "완료",
    disabledTitleColor: Colors.white.color,
    disabledBackgroundColor: Colors.gray500.color
  )
  
  private let disposeBag = DisposeBag()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    bind()
  }
  
  private func configureView() {
    view.addSubview(containerView)
    
    containerView.flex.define { flex in
      flex.addItem()
        .direction(.column)
        .padding(20)
        .define { flex in
          flex.addItem(firstButton)
            .marginBottom(20)
          flex.addItem(secondButton)
            .marginBottom(20)
          flex.addItem(thirdButton)
            .marginBottom(20)
          flex.addItem(forthButton)
        }
    }
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    containerView.pin
      .all(view.pin.safeArea)
    containerView.flex
      .layout()
  }
  
  private func bind() {
    [firstButton, secondButton, thirdButton].forEach { button in
      button.rx.tapped
        .subscribe(with: self, onNext: { owner, _ in
          owner.handleButtonTap(button: button)
        })
        .disposed(by: disposeBag)
    }
    
    forthButton.rx.tapped
      .map{ false }
      .bind(to: forthButton.isEnabled )
      .disposed(by: disposeBag)
  }
  
  private func handleButtonTap(button: WalWalButton) {
    print("Button tapped: \(button)")
  }
}
