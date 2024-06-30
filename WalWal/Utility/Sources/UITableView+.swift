//
//  UITableView+.swift
//  Utility
//
//  Created by Eddy on 6/26/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public extension UITableView {
    /// UITableViewCell 등록
    /// - Parameters:
    ///   - type: 등록할 cell 클래스 (예: UserTableViewCell.self)
    func register<T: UITableViewCell>(_ type: T.Type) where T: ReusableView {
      self.register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }

    /// UITableViewHeaderFooterView 등록
    /// - Parameters:
    ///   - type: 등록할 header, footer 클래스 (예: UserTableViewHeader.self)
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) where T: ReusableView {
      self.register(type, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }

    /// cell 재사용
    /// - Parameters:
    ///   - type: 사용할 cell 클래스(입력한 클래스 이름으로 identifier 만듦)
    ///   - indexPath: cell의 indexPath
    /// - Returns: UITableViewCell
    func dequeue<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T where T: ReusableView {
      return self.dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }

    /// header, footer 재사용
    /// - Parameter type: 사용할 header, footer 클래스(입력한 클래스 이름으로 identifier 만듦)
    /// - Returns: UITableViewHeaderFooterView
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T where T: ReusableView {
      return self.dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as! T
    }
}

