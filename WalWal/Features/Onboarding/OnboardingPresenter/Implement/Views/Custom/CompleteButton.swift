//
//  CompleteButton.swift
//  OnboardingPresenterView
//
//  Created by Jiyeon on 7/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

/// Onboarding에서 재사용하기 위한 다음 버튼
///
/// - Parameters:
///   - title: 버튼 타이틀 텍스트로 기본 값으로 "다음"을 가지고 있습니다.
///   - isEnable: 버튼 활성화 여부로, 초기에 활성화 여부를 설정할 수 있습니다.
final class CompleteButton: UIButton {
  
  /// 버튼 활성화 값에 따라 백그라운드 색 변경되도록 설정
  ///
  /// 사용예시
  /// ```swift
  /// nextButton.isEnable = true
  /// ```
  override var isEnabled: Bool {
    didSet {
      if self.isEnabled {
        backgroundColor = .systemOrange
      } else {
        backgroundColor = .lightGray
      }
    }
  }
  
  // MARK: - Initialize
  
  init(title: String = "다음", isEnable: Bool) {
    super.init(frame: .zero)
    isEnabled = isEnable
    layer.cornerRadius = 10
    setTitle(title, for: .normal)
    titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
