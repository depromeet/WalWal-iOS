//
//  RegisterBody.swift
//  AuthData
//
//  Created by Jiyeon on 8/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct RegisterBody: Encodable {
  let nickname: String
  let raisePet: String
  
  public init(nickname: String, raisePet: String) {
    self.nickname = nickname
    self.raisePet = raisePet
  }
}
