//
//  Reusable.swift
//  Utility
//
//  Created by Eddy on 6/26/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public protocol ReusableView: AnyObject {
  static var reuseIdentifier: String { get }
}

extension ReusableView {
  public static var reuseIdentifier: String {
    return String(describing: self)
  }
}
