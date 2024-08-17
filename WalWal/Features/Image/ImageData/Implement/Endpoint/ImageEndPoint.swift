//
//  ImageEndPoint.swift
//  ImageData
//
//  Created by 이지희 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import LocalStorage
import ImageData

import Alamofire

enum ImageEndPoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  
  case membersUploadComplete(body: MemberUploadBody)
  case membersUploadURL(body: MemberUploadUrlBody)
  case recordUploadComplete(body: MissionRecordUploadBody)
  case recordUploadURL(body: MissionRecordUploadURLBody)
  case uploadMemberImage(url: String)
  case uploadRecordImage(url: String)
}

extension ImageEndPoint {
  var baseURLType: URLType {
    switch self {
    case .membersUploadComplete, .membersUploadURL, .recordUploadComplete, .recordUploadURL:
      return .walWalBaseURL
    case let .uploadMemberImage(url):
      return .presignedURL(url)
    case let .uploadRecordImage(url):
      return .presignedURL(url)
    }
  }
  
  var path: String {
    switch self {
    case .membersUploadComplete:
      return "/images/members/me/upload-complete"
    case .membersUploadURL:
      return "/images/members/me/upload-url"
    case .recordUploadComplete:
      return "/images/members/me/upload-url"
    case .recordUploadURL:
      return "/images/mission-record/upload-url"
    case .uploadMemberImage, .uploadRecordImage:
      return ""
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .membersUploadURL, .membersUploadComplete, .recordUploadComplete, .recordUploadURL:
      return .post
    case .uploadMemberImage, .uploadRecordImage:
      return .put
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .membersUploadComplete(body):
      return .requestWithbody(body)
    case let .membersUploadURL(body):
      return .requestWithbody(body)
    case let .recordUploadComplete(body):
      return .requestWithbody(body)
    case let .recordUploadURL(body):
      return .requestWithbody(body)
    case .uploadMemberImage, .uploadRecordImage:
      return .upload
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .membersUploadURL, .membersUploadComplete:
      let token = (KeychainWrapper.shared.accessToken != nil) ?
      KeychainWrapper.shared.accessToken : UserDefaults.string(forUserDefaultsKey: .temporaryToken)
      return .authorization(token ?? "")
    case .recordUploadURL, .recordUploadComplete:
      return .authorization(
        KeychainWrapper.shared.accessToken ?? ""
      )
    case .uploadMemberImage, .uploadRecordImage:
      return .uploadJPEG
    }
  }
}
