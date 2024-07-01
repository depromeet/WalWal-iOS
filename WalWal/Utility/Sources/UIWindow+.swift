//
//  UIWindow+.swift
//  Utility
//
//  Created by Eddy on 6/26/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

/// 가장 상위의 `UIWindow`를 반환
/// guard let window = UIWindow.key else { return }
/// window.addSubview(loadingView)
public extension UIWindow {
    /// 찾지 못하였을 경우 `nil`을 반환합니다.
    static var key: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
