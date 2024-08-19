//
//  WalWalToastViewController.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem

public final class WalWalToastViewController: UIViewController {
  
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    WalWalToast.shared.show(type: .boost,  message: "테스트토스트", isTabBarExist: false)
  }
  
}
