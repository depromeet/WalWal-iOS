//
//  EmptyResponse.swift
//  WalWalNetworkImp
//
//  Created by 이지희 on 6/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

/// Response에 Data가 없는 경우, ```BaseResponse<EmptyResponse>```를 사용합니다.
public struct EmptyResponse: Decodable {}
