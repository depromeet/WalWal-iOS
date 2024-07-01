//
//  UICollectionView+.swift
//  Utility
//
//  Created by Eddy on 6/26/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public extension UICollectionView {
    /// UICollectionViewCell 등록
    /// - Parameter type: 등록할 UICollectionViewCell 클래스 (예: UserCollectionViewCell.self)
    func register<T: UICollectionViewCell>(_ : T.Type) where T: ReusableView {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    /// UICollectionView header 등록
    /// - Parameters:
    ///   - type: 등록할 UICollectionReusableView 클래스 (예: UserCollectionViewHeader.self)
    func registerHeader<T: UICollectionReusableView>(_ : T.Type) where T: ReusableView {
        self.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }
    /// UICollectionView footer 등록
    /// - Parameters:
    ///   - type: 등록할 UICollectionReusableView 클래스 (예: UserCollectionViewHeader.self)
    func registerFooter<T: UICollectionReusableView>(_ : T.Type) where T: ReusableView {
        self.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
    }

    /// UICollectionViewCell 재사용
    /// - Parameters:
    ///   - type: 사용할 UICollectionViewCell 클래스(입력한 클래스 이름으로 identifier 만듦)
    ///   - indexPath: cell의 indexPath
    /// - Returns: UICollectionViewCell?
    func dequeue<T: UICollectionViewCell>(_ : T.Type, for indexPath: IndexPath) -> T where T: ReusableView {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    /// UICollectionView header 재사용
    /// - Parameters:
    ///   - type: 사용할 UICollectionReusableView 클래스(입력한 클래스 이름으로 identifier 만듦)
    ///   - indexPath: header or footer의 indexPath
    /// - Returns: UICollectionReusableView?
    func dequeueHeader<T: UICollectionReusableView>(_ : T.Type, for indexPath: IndexPath) -> T where T: ReusableView {
        self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }

    /// UICollectionView footer 재사용
    /// - Parameters:
    ///   - type: 사용할 UICollectionReusableView 클래스(입력한 클래스 이름으로 identifier 만듦)
    ///   - indexPath: header or footer의 indexPath
    /// - Returns: UICollectionReusableView?
    func dequeueFooter<T: UICollectionReusableView>(_ : T.Type, for indexPath: IndexPath) -> T where T: ReusableView {
        self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
