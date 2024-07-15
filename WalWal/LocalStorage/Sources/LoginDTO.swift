//
//  LoginDTO.swift
//  LocalStorage
//
//  Created by Eddy on 7/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct LoginDTO: Codable, Equatable {
  var userId: String
  var authToken: String
}
