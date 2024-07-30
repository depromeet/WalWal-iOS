//
//  WalWalTabBarViewController.swift
//  DesignSystem
//
//  Created by 조용인 on 7/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout
import Then

public final class WalWalTabBarViewController: UITabBarController {
  
  // MARK: - UI
  
  private let customTabBar = WalWalTabBarView()
  
  // MARK: - Properties
  
  public private(set) var selectedFlow = BehaviorRelay<Int>(value: 0)
  
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
    
    customTabBar.pin
      .bottom(view.pin.safeArea)
      .left()
      .right()
      .height(68)
    
    customTabBar.flex.layout()
  }
  
  // MARK: - Methods

  func hideCustomTabBar() {
    self.tabBar.isHidden = true
    customTabBar.isHidden = true
  }
  
  func showCustomTabBar() {
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
    view.addSubview(customTabBar)
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
