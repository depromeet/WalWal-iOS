//
//  WalWalProfileViewDemoViewController.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/12/24.
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

public final class WalWalProfileViewDemoViewController: UIViewController {
  
  private let rootContainer = UIView()
  private let profileSelectView = WalWalProfile(type: .dog)
  private let disposeBag = DisposeBag()
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureLayout()
    bind()
  }
  
  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
  }
  
  private func configureLayout() {
    view.addSubview(rootContainer)
    rootContainer.flex
      .justifyContent(.center)
      .alignItems(.center)
      .define {
        $0.addItem(profileSelectView)
          .width(100%)
      }
  }
  
  private func bind() {
    profileSelectView.showPHPicker
      .bind(with: self) { owner, _ in
        PHPickerManager.shared.presentPicker(vc: owner)
      }
      .disposed(by: disposeBag)
    
  }
  
}
