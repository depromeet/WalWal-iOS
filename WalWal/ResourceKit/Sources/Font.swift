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
    /// 12px medium
    public static let M1 = UIFont.systemFont(ofSize: 12, weight: .medium)
    /// 14px regular
    public static let B1 = UIFont.systemFont(ofSize: 14, weight: .regular)
    /// 13px regular
    public static let B3 = UIFont.systemFont(ofSize: 13, weight: .regular)
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

/// 일단 롯데리아 챱챱만,,,,
extension ResourceKitFontFamily {
  public static func lineHeight(of font: ResourceKitFontConvertible.Font) -> CGFloat {
    if font == Self.LotteriaChab.Buster_Cute { return 95 }
    else if font == Self.LotteriaChab.Buster_Cool { return 50 }
    else if font == Self.LotteriaChab.Buster_Lovely { return 50 }
    else if font == Self.LotteriaChab.H1 { return 50 }
    else if font == Self.LotteriaChab.H2 { return 50 }
    else if font == Self.LotteriaChab.H3 { return 50 }
    else { return 0 }
  }
  
  public static func lineHeightPercent(of font: ResourceKitFontConvertible.Font) -> CGFloat? {
    if [KR.H2, KR.H6.B, KR.H6.M, KR.B2, KR.B3, KR.M1].contains(font) { return 130 } 
    else { return nil }
  }
  
  public static func spacingPercent(of font: ResourceKitFontConvertible.Font) -> CGFloat {
    if [KR.B1, KR.B2, KR.Caption, EN.B1, EN.B2, EN.Caption].contains(font) { return 0 }
    else { return -2.5 }
  }
}


