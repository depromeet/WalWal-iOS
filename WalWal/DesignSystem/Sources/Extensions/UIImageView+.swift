//
//  UIImageView+.swift
//  DesignSystem
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import Kingfisher

extension UIImageView {
    func kfSetImage(url: String?) {
        
        guard let url = url else { return }
        
        if let url = URL(string: url) {
            kf.indicatorType = .activity
            kf.setImage(with: url,
                        placeholder: nil,
                        options: [.transition(.fade(1.0))], progressBlock: nil)
        }
    }
}
