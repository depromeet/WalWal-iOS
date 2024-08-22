//
//  NetworkReachability.swift
//  WalWalNetworkImp
//
//  Created by 조용인 on 7/10/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import UIKit

import Alamofire
import RxSwift


enum NetworkStatusType {
  case disconnect
  case connect
  case unknown
}

/// 네트워크 연결 여부를 확인하는 싱글톤 클래스 입니다
public final class NetworkReachability {
  static let shared = NetworkReachability()
  
  /// Almofire에서 제공하는 네트워크 상태 매니저
  private let reachabilityManager = NetworkReachabilityManager()
  private let disposeBag = DisposeBag()
  fileprivate let statusPublish = PublishSubject<NetworkStatusType>()
  var statusObservable: Observable<NetworkStatusType>{
    statusPublish
  }
  
  private init() {
    observeReachability()
  }
  
  
  /// 네트워크 상태 변화를 나타내는 Observable
  /// 사용 예시
  /// ``` swift
  ///  NetworkReachability.shared.statusObservable
  ///   .subscribe (onNext: {
  ///      print($0)
  ///   })
  ///   .dispose(by: disposeBag)
  /// ```
  public func observeReachability() {
    let reachability = NetworkReachabilityManager()
    reachability?.startListening(onUpdatePerforming: { [weak statusPublish] status in
      switch status {
      case .notReachable:
        statusPublish?.onNext(.disconnect)
      case .reachable(.cellular), .reachable(.ethernetOrWiFi):
        statusPublish?.onNext(.connect)
      case .unknown:
        statusPublish?.onNext(.unknown)
      }
    })
  }
  
  /// 네트워크가 연결되었는지 확인하는 메서드
  ///
  /// 사용 예시
  /// ``` swift
  /// view.backgroundColor = NetworkReachability.shared.isReachable() ? .blue : .gray
  /// ```
  public func isReachable() -> Bool {
    return reachabilityManager?.isReachable ?? false
  }
  
  /// 네트워크 상태 모니터링 중지
  func stopMonitoring() {
    reachabilityManager?.stopListening()
  }
}

