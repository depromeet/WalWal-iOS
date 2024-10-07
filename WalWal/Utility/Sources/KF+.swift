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

public final class ImageCacheManager {
  
  public static let shared = ImageCacheManager()
  
  private let memoryLimit: Int = 50 * 1024 * 1024
  private let countLimit: Int = 100
  
  private let disposeBag = DisposeBag()
  
  private init() {
    configureImageCacher()
    observeMemoryWarnings()
  }

  private func configureImageCacher() {
    let cache = ImageCache.default
    cache.memoryStorage.config.totalCostLimit = memoryLimit
    cache.memoryStorage.config.countLimit = countLimit
  }
  
  private func observeMemoryWarnings() {
    NotificationCenter.default.rx
      .notification(UIApplication.didReceiveMemoryWarningNotification)
      .withUnretained(self)
      .subscribe(onNext: { owner,_ in
        let usedMemory = owner.getUsedMemory()
        print("😵 메모리 초과: \(usedMemory / 1024 / 1024)MB 사용 중, 캐시 비우기 실행")
        
      })
      .disposed(by: disposeBag)
  }
  
  /// 현재 앱의 메모리 사용량을 확인하는 메서드
  private func getUsedMemory() -> Int {
    var info = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
    let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
      $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
        task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
      }
    }
    
    if kerr == KERN_SUCCESS {
      return Int(info.resident_size)
    } else {
      return 0
    }
  }
  
  /// 이미지를 다운로드하는 메서드
  public func downloadImage(for imageUrl: String, isSmallImage: Bool = false) -> Observable<UIImage?> {
    return Observable.create { observer in
      guard let url = URL(string: imageUrl) else {
        observer.onNext(nil)
        observer.onCompleted()
        return Disposables.create()
      }
      
      /// Kingfisher를 사용해 이미지 다운로드 및 캐싱
      let resource = KF.ImageResource(downloadURL: url)
      let targetSize = isSmallImage ? CGSize(width: 40, height: 40) : CGSize(width: 343, height: 343)
      let processor = DownsamplingImageProcessor(size: targetSize)
      KingfisherManager.shared.retrieveImage(
        with: resource,
        options: [.processor(processor), .scaleFactor(UIScreen.main.scale)]
      ) { result in
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
