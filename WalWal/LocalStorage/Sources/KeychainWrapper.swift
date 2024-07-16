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

  // MARK: - loginInfo

  /// loingInfo의 authToken, userID에 접근이 가능합니다.
  /// KeychainWrapper.shared.loginInfo?.authToken
  /// KeychainWrapper.shared.loginInfo?.userId
  public var loginInfo: LoginDTO? {
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
       let authTokenData = existingItem[kSecValueData as String] as? Data,
       let authToken = String(data: authTokenData, encoding: .utf8),
       let userId = existingItem[kSecAttrAccount as String] as? String
    {
      return LoginDTO(
        userId: userId,
        authToken: authToken
      )
    } else {
      print("키체인에서 LoginDTO 불러오기 실패: \(status)")
      return nil
    }
  }

  /// loginInfo에 있는 프로퍼티의 값을 설정합니다.
  /// KeychainWrapper.shared.setLoginInfo(.init(userId: "userID", authToken: "authToken"))
  public func setLoginInfo(_ loginDTO: LoginDTO?) -> Bool {
    if let loginDTO = loginDTO {
      if loginInfo == nil {
        return addLoginInfo(loginDTO)
      } else {
        return updateLoginInfo(loginDTO)
      }
    } else {
      return deleteLoginInfo()
    }
  }

  /// 로그인 정보 키체인 저장 함수
  private func addLoginInfo(_ loginDTO: LoginDTO) -> Bool {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: userKey,
      kSecAttrAccount: loginDTO.userId,
      kSecValueData: loginDTO.authToken.data(using: .utf8) as Any,
      kSecAttrLabel: "\(loginDTO.authToken)"
    ]

    let status = SecItemAdd(query as CFDictionary, nil)

    if status == errSecDuplicateItem {
      return updateLoginInfo(loginDTO)
    } else {
      assert(status == errSecSuccess, "로그인 정보 키체인 저장 실패")
      return status == errSecSuccess
    }
  }

  /// 로그인 정보 키체인 업데이트 함수
  private func updateLoginInfo(_ loginDTO: LoginDTO) -> Bool {
    let prevQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: userKey,
      kSecAttrAccount: loginDTO.userId,
    ]

    let updateQuery: [CFString: Any] = [
      kSecAttrAccount: loginDTO.userId,
      kSecValueData: loginDTO.authToken.data(using: .utf8) as Any,
      kSecAttrLabel: "\(loginDTO.authToken)"
    ]

    let status = SecItemUpdate(
      prevQuery as CFDictionary,
      updateQuery as CFDictionary
    )
    assert(status == errSecSuccess, "로그인 정보 키체인 갱신 실패")
    return status == errSecSuccess
  }

  /// 로그인 정보 키체인 삭제 함수
  private func deleteLoginInfo() -> Bool {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: userKey
    ]

    let status = SecItemDelete(query as CFDictionary)
    assert(status == errSecSuccess, "로그인 정보 키체인 삭제 실패")
    return status == errSecSuccess
  }
}
