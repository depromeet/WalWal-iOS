//
//  NavigationBarColorSet.swift
//  DesignSystem
//
//  Created by 조용인 on 7/29/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ResourceKit

public enum NavigationBarColorSet {
    case clear
    case setted
    
    var backgroundColor: UIColor {
        switch self {
        case .clear:
            return .clear
        case .setted:
            return ResourceKitAsset.Colors.white.color
        }
    }
}
