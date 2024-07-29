//
//  WalWalNavigationBarDemoViewController.swift
//  DesignSystem
//
//  Created by 조용인 on 7/29/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit

import PinLayout
import FlexLayout
import RxSwift
import RxGesture

final class WalWalNavigationBarDemoViewController: UIViewController {
  
  // MARK: - UI
  
  private let navigaionBar = WalWalNavigationBar(
    leftItems: [
      .back,
    ],
    title: "WALWAL NavigationBar",
    rightItems: [
      .close,
      .setting
    ],
    colorType: .normal
  )
  
  private let containerView = UIView()
  
  // MARK: - Properties
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.containerView)
    self.configureLayouts()
    self.navigationController?.navigationBar.isHidden = true
    self.navigationController?.navigationItem.title = "WalWal"
    self.view.backgroundColor = .white
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.containerView.pin.all(self.view.pin.safeArea)
    self.containerView.flex.layout()
  }
  
  // MARK: - Methods
  
  private func bind() {
    navigaionBar.leftItems?[0].rx.tap
      .debug()
      .subscribe(with: self, onNext: { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
}


// MARK: - Private Methods

extension WalWalNavigationBarDemoViewController {
  private func configureLayouts() {
    self.containerView.backgroundColor = ResourceKitAsset.Colors.walwalOrange.color
    self.containerView.flex
      .direction(.column)
      .define { flex in
        flex.addItem(navigaionBar)
          .width(100%)
      }
  }
}
