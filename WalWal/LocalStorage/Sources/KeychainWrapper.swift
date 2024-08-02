//
//  KeychainWrapper.swift
//  LocalStorage
//
//  Created by Eddy on 7/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

/// 키체인
public final class KeychainWrapper {
  public static let shared = KeychainWrapper()
  
  // MARK: - Key
  
  public let userKey = "kr.co.walwal.user"
  public let UUIDKey = "kr.co.walwal.uuid"
  
  // MARK: - deviceUUID
  
  /// deviceUUID의 값을 접근합니다.
  /// KeychainWrapper.shared.deviceUUID
  public var deviceUUID: String {
    var query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: UUIDKey,
      kSecMatchLimit: kSecMatchLimitOne,
      kSecReturnData: true
    ]
    var item: CFTypeRef?
    var status = SecItemCopyMatching(query as CFDictionary, &item)
    
    if status == errSecSuccess,
       let existingItem = item as? Data,
       let uuid = String(data: existingItem, encoding: .utf8) {
      return uuid
    }
    
    let deviceUUID = UUID().uuidString
    query = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: UUIDKey,
      kSecValueData: deviceUUID.data(using: .utf8) as Any
    ]
    
    status = SecItemAdd(query as CFDictionary, nil)
    
    if status != errSecSuccess {
      /// UUID 저장에 실패한 경우, 기존 항목을 삭제하고 다시 시도
      if status == errSecDuplicateItem {
        SecItemDelete(query as CFDictionary)
        status = SecItemAdd(query as CFDictionary, nil)
      }
      if status != errSecSuccess {
        assert(status == errSecSuccess, "deviceUUID (\(deviceUUID)) 키체인 저장 실패")
      }
    }
    return deviceUUID
  }
  
  // MARK: - AccessToken
  
  /// AccessToken에 접근이 가능합니다.
  ///
  /// `KeychainWrapper.shared.accessToken`
  public var accessToken: String? {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: userKey,
      kSecMatchLimit: kSecMatchLimitOne,
      kSecReturnAttributes: true,
      kSecReturnData: true
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    if status == errSecSuccess,
       let existingItem = item as? [String: Any],
       let accessTokenData = existingItem[kSecValueData as String] as? Data,
       let accessToken =  String(data: accessTokenData, encoding: .utf8)
    {
      return accessToken
    } else {
      print("키체인에서 AccessToken 불러오기 실패: \(status)")
      return nil
    }
  }
  
  /// loginInfo에 있는 프로퍼티의 값을 설정합니다.
  ///
  /// `KeychainWrapper.shared.setAccessToken("token")`
  public func setAccessToken(_ accessToken: String?) -> Bool {
    if let accessToken = accessToken {
      if self.accessToken == nil {
        return addAccessToken(accessToken)
      } else {
        return updateAccessToken(accessToken)
      }
    } else {
      return deleteAccessToken()
    }
  }
  
  /// AccessToken 키체인 저장 함수
  private func addAccessToken(_ accessToken: String) -> Bool {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: userKey,
      kSecAttrAccount: "AccessToken",
      kSecValueData: (accessToken as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any,
      kSecAttrLabel: "AccessToken"
    ]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    
    if status == errSecDuplicateItem {
      return updateAccessToken(accessToken)
    } else {
      assert(status == errSecSuccess, "AccessToken 키체인 저장 실패")
      return status == errSecSuccess
    }
  }
  
  /// AccessToken 키체인 업데이트 함수
  private func updateAccessToken(_ accessToken: String) -> Bool {
    let prevQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: userKey,
    ]
    
    let updateQuery: [CFString: Any] = [
      kSecValueData: (accessToken as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any,
      kSecAttrLabel: "AccessToken"
    ]
    
    let status = SecItemUpdate(
      prevQuery as CFDictionary,
      updateQuery as CFDictionary
    )
    assert(status == errSecSuccess, "AccessToken 키체인 갱신 실패")
    return status == errSecSuccess
  }
  
  /// AccessToken 키체인 삭제 함수
  private func deleteAccessToken() -> Bool {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: userKey
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    assert(status == errSecSuccess, "AccessToken 키체인 삭제 실패")
    return status == errSecSuccess
  }
}
