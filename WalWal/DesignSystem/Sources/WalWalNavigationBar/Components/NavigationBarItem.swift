//
//  NavigationBarItem.swift
//  DesignSystem
//
//  Created by 조용인 on 7/29/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import RxSwift

public final class NavigationBarItem: UIButton {
  
  public private(set) var type: NavigationBarItemType
  
  public init(_ type: NavigationBarItemType) {
    self.type = type
    super.init(frame: .zero)
    configureIcon(icon: type.icon)
  }
  
  @available (*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureIcon(icon: UIImage?) {
    guard let tintedImage = type.icon?.withRenderingMode(.alwaysTemplate) else {
      self.setImage(nil, for: .normal)
      return
    }
    
    self.setImage(tintedImage, for: .normal)
  }
}

