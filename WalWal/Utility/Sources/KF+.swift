//
//  KF+.swift
//  Utility
//
//  Created by 조용인 on 8/18/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

public struct ImageCacheManager {
  
  public init() { }
  
  /// 이미지를 다운로드하는 메서드
  public func downloadImage(for imageUrl: String) -> Observable<UIImage?> {
    return Observable.create { observer in
      guard let url = URL(string: imageUrl) else {
        observer.onNext(nil)
        observer.onCompleted()
        return Disposables.create()
      }
      
      /// Kingfisher를 사용해 이미지 다운로드 및 캐싱
      let resource = KF.ImageResource(downloadURL: url)
      KingfisherManager.shared.retrieveImage(with: resource) { result in
        switch result {
        case .success(let value):
          observer.onNext(value.image)
        case .failure(let error):
          print("""
                      - 😵 Kingfisher 이미지 다운로드 실패
                      - 😵 imageUrl: \(url)
                      - 😵 error: \(error)
                      """)
          observer.onNext(nil)
        }
        observer.onCompleted()
      }
      
      return Disposables.create()
    }
  }
}
