//
//  ErrorResponse.swift
//  WalWalNetwork
//
//  Created by Jiyeon on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
  public var errorClassName: String
  public var message: String
}
