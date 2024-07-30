//
//  PHPickerManager.swift
//  Utility
//
//  Created by Jiyeon on 7/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import PhotosUI

import RxSwift

final public class PHPickerManager {
  private weak var viewController: UIViewController?
  
  /// 선택한 사진을 전달하기위한 프로퍼티
  ///
  /// 사용 예시:
  /// ```swift
  /// PHPickerManager().selectedPhoto
  /// .compactMap { $0 }
  /// .bind(with: self) { owner, image in
  ///   imageView.image = image
  /// }
  /// .disposed(by: disposeBag)
  /// ```
  public let selectedPhoto = PublishSubject<UIImage?>()
  
  public init(){}
  
  /// 사용자 앨범을 보여주기 위한 메서드
  ///
  /// 사용예시
  /// ```swift
  /// button.rx.tap
  ///   .bind(with: self) { owner, _ in
  ///     PHPickerManager().presentPicker
  ///   }
  ///   .disposed(by: disposBag)
  ///  ```
  public func presentPicker(vc: UIViewController) {
    self.viewController = vc
    let filter = PHPickerFilter.images
    var configuration = PHPickerConfiguration()
    configuration.filter = filter
    configuration.selectionLimit = 1
    
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    viewController?.present(picker, animated: true)
  }
}

extension PHPickerManager: PHPickerViewControllerDelegate {
  
  public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    let provider = results.first?.itemProvider
    if let provider = provider {
      
      if provider.canLoadObject(ofClass: UIImage.self) {
        provider.loadObject(ofClass: UIImage.self) { image, error in
          guard let selectedImage = image as? UIImage else { return }
          self.selectedPhoto.onNext(selectedImage)
        }
      }
    }
  }
}
