//
//  Images.swift
//  ResourceKit
//
//  Created by 조용인 on 8/6/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

extension UIImage {
    public func rotate(radians: CGFloat) -> UIImage? {
        let newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: radians)).size
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // Move the origin to the middle of the image so we will rotate and scale around the center.
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate the image context
        context.rotate(by: radians)
        // Now, draw the rotated/scaled image into the context
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage
    }
}

/// UIImage를 180도 회전시키기
/// if let image = UIImage(named: "이미지 이름") {
///     let rotatedImage = image.rotate(radians: .pi) // .pi는 180도에 해당하는 라디안 값입니다.
/// }

