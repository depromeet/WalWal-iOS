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
    title: "최대 12글자 들어간다",
    rightItems: [
      .close,
      .setting
    ],
    colorType: .orange
  )
  
  private let containerView = UIView().then {
    $0.backgroundColor = ResourceKitAsset.Colors.white.color
  }
  
  // MARK: - Properties
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  public init() {
    super.init(nibName: nil, bundle: nil)
    configureAttributes()
    configureLayouts()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.containerView.pin
      .all(self.view.pin.safeArea)
    self.containerView.flex
      .layout()
  }
  
  // MARK: - Methods
  
  private func bind() {
    navigaionBar.leftItems?[0].rx.tapped
      .subscribe(with: self, onNext: { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
}


// MARK: - Private Methods

private extension WalWalNavigationBarDemoViewController {
  func configureAttributes() {
    self.navigationController?.isNavigationBarHidden = true
    self.navigationController?.navigationItem.title = "WalWal"
  }
  
  func configureLayouts() {
    self.view.addSubview(self.containerView)
    self.containerView.flex
      .direction(.column)
      .define { flex in
        flex.addItem(navigaionBar)
          .width(100%)
      }
  }
}
