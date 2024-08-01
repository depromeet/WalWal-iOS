//
//  BaseResponse.swift
//  WalWalNetworkImp
//
//  Created by 이지희 on 6/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//
import Foundation

/// Response에 공통적으로 포함되는 모델을 정의합니다.
/// data는 때에 따라 없는 경우도 존재하기 때문에 옵셔널로 정의
public struct BaseResponse<T>: Decodable where T: Decodable {
  public var status: Int
  public var success: Bool
  public var data: T?
}
