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
  
  private let containerView = UIView().then {
    $0.backgroundColor = Colors.gray600.color
  }
  
  let firstButton = WalWalButton(type: .inactive, title: "기본 버튼")
  
  let secondButton = WalWalButton(type: .inactive, title: "비활성화 버튼")
  
  let thirdButton = WalWalButton(type: .inactive, title: "어두운 버튼")
  
  let buttonLabel = UILabel().then {
    $0.text = "버튼을 눌러보세요!"
    $0.font = Fonts.KR.H4
    $0.sizeToFit()
  }
  
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
          flex.addItem(buttonLabel)
        }
    }
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    containerView.pin
      .all(view.pin.safeArea)
    containerView.flex
      .layout(mode: .adjustHeight)
    
    [firstButton, secondButton, thirdButton].forEach { button in
      button.flex.width(containerView.bounds.width - 40)
    }
  }
  
  private func bind() {
    
    firstButton.rx.tapped
      .subscribe(with: self, onNext: { owner, _ in
        owner.firstButton.rx.buttonType.onNext(.disabled)
        owner.firstButton.rx.title.onNext("으아ㅏㅏㅏㅏㅏㅏ")
      })
      .disposed(by: disposeBag)
    
    secondButton.rx.tapped
      .subscribe(with: self, onNext: { owner, _ in
        owner.secondButton.rx.buttonType.onNext(.disabled)
        owner.secondButton.rx.title.onNext("🔥")
      })
      .disposed(by: disposeBag)
    
    thirdButton.rx.tapped
      .subscribe(with: self, onNext: { owner, _ in
        owner.thirdButton.rx.buttonType.onNext(.disabled)
        owner.thirdButton.rx.title.onNext("3번째 입니다")
      })
      .disposed(by: disposeBag)
  }
}
