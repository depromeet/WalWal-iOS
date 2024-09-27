//
//  StoreReviewManager.swift
//  Utility
//
//  Created by Jiyeon on 9/25/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import StoreKit

public final class StoreReviewManager {
  
  public static let shared = StoreReviewManager()
  private init() { }
  
  private let minimumReviewRequestCount = 5
  
  public func requestReview(missionCount: Int) {
    guard missionCount >= minimumReviewRequestCount else { return }
    
    guard let scene = UIApplication.shared.connectedScenes.first(where: {
      $0.activationState == .foregroundActive
    }) as? UIWindowScene else {
      return
    }
    SKStoreReviewController.requestReview(in: scene)
  }
}
