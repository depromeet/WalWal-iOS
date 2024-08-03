//
//  Font.swift
//  ResourceKit
//
//  Created by 조용인 on 7/25/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

extension ResourceKitFontFamily {
  
  /// 사용 방법
  /// $0.font = ResourceKitFontFamily.KR.H1
  public struct KR {
    /// 32px bold
    public static let H1 = UIFont.systemFont(ofSize: 32, weight: .bold)
    /// 28px bold
    public static let H2 = UIFont.systemFont(ofSize: 28, weight: .bold)
    /// 24px bold
    public static let H3 = UIFont.systemFont(ofSize: 24, weight: .bold)
    /// 20px bold
    public static let H4 = UIFont.systemFont(ofSize: 20, weight: .bold)
    /// 18px
    public struct H5 {
      public static let B = UIFont.systemFont(ofSize: 18, weight: .bold)
      public static let M = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    /// 16px
    public struct H6 {
      public static let B = UIFont.systemFont(ofSize: 16, weight: .bold)
      public static let M = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    /// 14px
    public struct H7 {
      public static let B = UIFont.systemFont(ofSize: 14, weight: .bold)
      public static let SB = UIFont.systemFont(ofSize: 14, weight: .semibold)
      public static let M = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    /// 14px regular
    public static let B1 = UIFont.systemFont(ofSize: 14, weight: .regular)
    /// 12px regular
    public static let B2 = UIFont.systemFont(ofSize: 12, weight: .regular)
    /// 10px regular
    public static let Caption = UIFont.systemFont(ofSize: 10, weight: .regular)
  }
  
  /// 사용 방법
  /// $0.font = ResourceKitFontFamily.EN.H1
  public struct EN {
    /// 16px bold
    public static let H1 = UIFont.systemFont(ofSize: 16, weight: .bold)
    /// 14px semibold
    public static let H2 = UIFont.systemFont(ofSize: 14, weight: .semibold)
    /// 14px medium
    public static let H3 = UIFont.systemFont(ofSize: 14, weight: .medium)
    /// 14px regular
    public static let B1 = UIFont.systemFont(ofSize: 14, weight: .regular)
    /// 12px semibold
    public static let B2 = UIFont.systemFont(ofSize: 12, weight: .semibold)
    /// 12px regular
    public static let Caption = UIFont.systemFont(ofSize: 12, weight: .regular)
  }
}

extension ResourceKitFontFamily.LotteriaChab {
  /// 사용 방법
  /// $0.font = ResourceKitFontFamily.LotteriaChab.H1
  public static let Buster_Cute = Self.regular.font(size: 80)
  public static let Buster_Cool = Self.regular.font(size: 90)
  public static let Buster_Lovely = Self.regular.font(size: 64)
  public static let H1 = Self.regular.font(size: 48)
  public static let H2 = Self.regular.font(size: 34)
  public static let H3 = Self.regular.font(size: 24)
}
