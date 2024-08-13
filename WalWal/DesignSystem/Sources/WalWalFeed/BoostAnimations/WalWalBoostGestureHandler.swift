//
//  WalWalBoostGestureHandler.swift
//  DesignSystem
//
//  Created by 조용인 on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

protocol GestureHandlerDelegate: AnyObject {
    func gestureHandlerDidBeginLongPress(_ gesture: UILongPressGestureRecognizer)
    func gestureHandlerDidEndLongPress(_ gesture: UILongPressGestureRecognizer)
}

final class WalWalBoostGestureHandler: NSObject {
    
    weak var delegate: GestureHandlerDelegate?
    
    func setupLongPressGesture(for view: UIView) {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        view.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            delegate?.gestureHandlerDidBeginLongPress(gesture)
        case .ended, .cancelled:
            delegate?.gestureHandlerDidEndLongPress(gesture)
        default:
            break
        }
    }
}
