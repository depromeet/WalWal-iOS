//
//  WalWalInputBoxDemoViewController.swift
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

final class WalWalInputBoxDemoViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  private let rootFlexContainer = UIView().then {
    $0.backgroundColor = ResourceKitAsset.Colors.gray700.color
  }
  
  private let normalInputBox = WalWalInputBox(
    defaultState: .active,
    placeholder: "일반 입력",
    rightIcon: .close
  )
  
  private let passwordInputBox = WalWalInputBox(
    defaultState: .active,
    placeholder: "비밀번호 입력",
    rightIcon: .show
  )
  
  private let disabledInputBox = WalWalInputBox(
    defaultState: .active,
    placeholder: "비활성화 입력"
  )
  
  private let errorInputBox = WalWalInputBox(
    defaultState: .active,
    placeholder: "에러 상태 입력",
    rightIcon: .close
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    view.addSubview(rootFlexContainer)
    
    setupLayout()
    setupBindings()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    rootFlexContainer.pin
      .all(view.pin.safeArea)
    rootFlexContainer.flex
      .layout()
  }
  
  private func setupLayout() {
    rootFlexContainer.flex
      .define { flex in
        flex.addItem(normalInputBox)
          .marginHorizontal(20)
          .marginTop(20)
        flex.addItem(passwordInputBox)
          .marginHorizontal(20)
          .marginTop(20)
        flex.addItem(disabledInputBox)
          .marginHorizontal(20)
          .marginTop(20)
        flex.addItem(errorInputBox)
          .marginHorizontal(20)
          .marginTop(20)
      }
  }
  
  private func setupBindings() {
    /// 일반 입력 박스
    normalInputBox.rx.text
      .orEmpty
      .distinctUntilChanged()
      .subscribe(onNext: { text in
        print("Normal input: \(text)")
      })
      .disposed(by: disposeBag)
    
    /// 비밀번호 입력 박스
    passwordInputBox.rx.text
      .orEmpty
      .distinctUntilChanged()
      .subscribe(onNext: { text in
        print("Password input: \(text)")
      })
      .disposed(by: disposeBag)
    
    /// 비활성화 입력 박스
    disabledInputBox.stateRelay.accept(.inActive)
    
    /// 에러 상태 입력 박스
    errorInputBox.rx.controlEvent(.editingDidEnd)
      .withLatestFrom(errorInputBox.rx.text.orEmpty)
      .subscribe(with: self, onNext: { owner, text in
        if text.count < 5 && text.count > 0 {
          owner.errorInputBox.rx.errorMessage.onNext("5글자 이상 입력해주세요")
        } else {
          owner.errorInputBox.rx.errorMessage.onNext(nil)
        }
      })
      .disposed(by: disposeBag)
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    guard let touch = touches.first else { return }
    let location = touch.location(in: view)
    
    let inputBoxes = [normalInputBox, passwordInputBox, disabledInputBox, errorInputBox]
    let touchedOutside = inputBoxes.allSatisfy { !$0.frame.contains(location) }
    
    if touchedOutside {
      view.endEditing(true)
    }
  }
}
