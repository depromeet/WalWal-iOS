//
//  UIView+.swift
//  DesignSystem
//
//  Created by 조용인 on 7/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

extension Reactive where Base: UIView {
  
  /// UIView를 Tap했을 때,  `ControlEvent<Void>` 를 방출하는 property 입니다.
  /// - Returns: `ControlEvent<Void>`
  public var tapped: ControlEvent<Void> {
    let event: Observable<Void> = base.rx.tapGesture()
      .when(.recognized)
      .map{ _ in }
    return ControlEvent(events: event)
  }
}
