//
//  WalWalTabBarViewController.swift
//  DesignSystem
//
//  Created by 조용인 on 7/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout
import Then

public final class WalWalTabBarViewController: UITabBarController {
  
  // MARK: - UI
  
  private let containerView = UIView().then {
    $0.backgroundColor = ResourceKitAsset.Colors.white.color
  }
  
  private let customTabBar = WalWalTabBarView()
  
  // MARK: - Properties
  
  public private(set) var selectedFlow = PublishRelay<Int>()
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureAttributs()
    configureViews()
    bind()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.showCustomTabBar()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    additionalSafeAreaInsets.bottom = 68
    containerView.pin
      .bottom()
      .left()
      .right()
      .height(view.safeAreaInsets.bottom)
    
    containerView.flex
      .layout()
  }
  
  // MARK: - Methods

  public func hideCustomTabBar() {
    self.tabBar.isHidden = true
    customTabBar.isHidden = true
  }
  
  public func showCustomTabBar() {
    self.tabBar.isHidden = true
    customTabBar.isHidden = false
  }
}

// MARK: - Private Methods

extension WalWalTabBarViewController {
  private func configureAttributs() {
    self.tabBar.isHidden = true
  }
  
  private func configureViews() {
    view.addSubview(containerView)
    
    containerView.flex
      .define { flex in
        flex.addItem(customTabBar)
          .grow(1)
      }
  }
  
  private func bind() {
    customTabBar.selectedIndex
      .distinctUntilChanged()
      .subscribe(with: self, onNext: { owner, index in
        owner.selectedFlow.accept(index)
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - Extension UITabBarControllerDelegate

extension WalWalTabBarViewController: UITabBarControllerDelegate {
  public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    return false
  }
}