//
//  WalWalButtonType.swift
//  DesignSystem
//
//  Created by 조용인 on 8/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import UIKit
import ResourceKit

public enum WalWalButtonType {
    case normal
    case icon
    
    var marginVertical: CGFloat {
        switch self {
        case .normal: return 17
        case .icon: return 15
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .normal, .icon: return 14
        }
    }
    
    var font: UIFont {
        switch self {
        case .normal: return ResourceKitFontFamily.KR.H5.B
        case .icon: return ResourceKitFontFamily.KR.H7.B
        }
    }
}
