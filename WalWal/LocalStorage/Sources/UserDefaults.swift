//
//  UserDefaults.swift
//  LocalStorage
//
//  Created by Eddy on 7/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

/// UserDefault
public extension UserDefaults {
  /// key 모음
  /// 필요한 type case를 추가합니다.
  enum Key: String {
    case notification
    case refreshToken
    case temporaryToken
    case isAlreadyLoaded
    case socialLogin
  }
  
  // MARK: - GET
  
  /// UserDefaults.string(forUserDefaultsKey: .notification)
  static func string(forUserDefaultsKey key: UserDefaults.Key) -> String {
    UserDefaults.standard.string(forKey: key.rawValue) ?? ""
  }
  
  static func bool(forUserDefaultsKey key: UserDefaults.Key) -> Bool {
    UserDefaults.standard.bool(forKey: key.rawValue)
  }
  
  static func integer(forUserDefaultsKey key: UserDefaults.Key) -> Int {
    UserDefaults.standard.integer(forKey: key.rawValue)
  }
  
  static func float(forUserDefaultsKey key: UserDefaults.Key) -> Float {
    UserDefaults.standard.float(forKey: key.rawValue)
  }
  
  static func object(forUserDefaultsKey key: UserDefaults.Key) -> Any? {
    UserDefaults.standard.object(forKey: key.rawValue)
  }
  
  // MARK: - SET
  
  /// UserDefaults 값을 추가한다.
  /// UserDefaults.setValue(value: deviceToken, forUserDefaultKey: .device)
  static func setValue(
    value: Any?,
    forUserDefaultKey key: UserDefaults.Key
  ) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
  }
  
  /// UserDefaults 값 삭제
  /// `UserDefaults.remove(forUserDefaultKey.remove(.accessToken)`
  static func remove(forUserDefaultKey key: UserDefaults.Key) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }
  
}
