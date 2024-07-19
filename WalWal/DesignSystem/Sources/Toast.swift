//
//  Toast.swift
//  DesignSystem
//
//  Created by Eddy on 7/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import Utility

import FlexLayout
import PinLayout

/// `Toast`는 앱 전체에서 토스트 메시지를 표시하는데 사용되는 클래스입니다.
public final class Toast {

  /// 토스트의 싱글톤 인스턴스
  ///
  /// 사용 예시:
  /// ```swift
  /// Toast.shared
  /// ```
  public static let shared = Toast()

  /// 토스트 좌우 마진
  private let containerLeadingTrailingInset: CGFloat = 24
  /// 토스트 하단 마진
  private let containerBottomInset: CGFloat = 47
  /// 토스트 최소 높이
  private let minimumContainerHeight: CGFloat = 51
  /// 토스트 좌우 패딩
  private let labelLeadingTrailingInset: CGFloat = 12
  /// 토스트 상하 패딩
  private let labelTopBottomInset: CGFloat = 17
  /// 토스트가 나타나는 시간 (단위: 초)
  private let fadeInDuration: TimeInterval = 0.25
  /// 토스트가 사라지기 시작하는데까지의 대기 시간 (단위: 초)
  private let delayBeforeFadeOut: TimeInterval = 2
  /// 토스트가 사라지는 시간 (단위: 초)
  private let fadeOutDuration: TimeInterval = 0.5

  /// 토스트가 현재 화면에 표시 중인지 여부
  ///
  /// 사용 예시:
  /// ```swift
  /// if Toast.shared.isToastShowing {
  ///     print("토스트가 보이는 중")
  /// }
  /// else {
  ///     print("토스트가 보이지 않는 중")
  /// }
  /// ```
  public var isToastShowing: Bool = false

  /// 토스트 메시지를 만들고 화면에 표시하는 함수
  ///
  /// - Parameters:
  ///   - message: 표시하려는 문자열 메시지입니다.
  ///   - completion: 토스트가 사라진 후 실행될 클로저입니다. (기본값은 nil)
  ///
  /// 사용 예시:
  /// ```swift
  /// Toast.shared.show("안녕하세요!") {
  ///     print("토스트 메시지가 사라진 후 이 메시지가 출력됩니다.")
  /// }
  /// ```
  @MainActor
  public func show(_ message: String, completion: (() -> Void)? = nil) {
    let toastContainer = self.createToastContainer()
    let toastLabel = self.createToastLabel(message: message)

    guard let window = UIWindow.key else {
      return
    }
    window.addSubview(toastContainer)
    toastContainer.addSubview(toastLabel)
    window.bringSubviewToFront(toastContainer)

    self.layoutToastContainer(toastContainer)
    self.layoutToastLabel(toastLabel)

    self.render(toastContainer, completion: completion)
  }

  /// 토스트 컨테이너를 생성하는 함수
  private func createToastContainer() -> UIView {
    let toastContainer = UIView(frame: CGRect())
    toastContainer.backgroundColor = .systemGray
    toastContainer.layer.cornerRadius = 10
    toastContainer.clipsToBounds = true
    toastContainer.alpha = 0.0
    return toastContainer
  }

  /// 토스트 레이블을 생성하는 함수
  private func createToastLabel(message: String) -> UILabel {
    let toastLabel = UILabel(frame: CGRect())
    toastLabel.text = message
    toastLabel.textColor = .white
    toastLabel.font = .systemFont(ofSize: 14, weight: .bold)
    toastLabel.numberOfLines = 0
    toastLabel.textAlignment = .center
    return toastLabel
  }

  /// 토스트 컨테이너의 레이아웃을 설정하는 함수
  private func layoutToastContainer(_ toastContainer: UIView) {
    toastContainer.flex
      .paddingHorizontal(containerLeadingTrailingInset)
      .paddingBottom(containerBottomInset)
      .height(minimumContainerHeight)
      .alignItems(.center)
      .define {
        $0.addItem()
          .marginHorizontal(labelLeadingTrailingInset)
          .marginVertical(labelTopBottomInset)
      }

    toastContainer.pin
      .left(containerLeadingTrailingInset)
      .right(containerLeadingTrailingInset)
      .bottom(containerBottomInset)
      .height(minimumContainerHeight)
  }

  /// 토스트 레이블의 레이아웃을 설정하는 함수
  private func layoutToastLabel(_ toastLabel: UILabel) {
    toastLabel.flex
      .marginHorizontal(labelLeadingTrailingInset)
      .marginVertical(labelTopBottomInset)

    toastLabel.pin.all()
  }

  /// 토스트를 렌더링하는 함수
  /// 토스트를 나타나게 한 뒤 사라지게 합니다.
  private func render(_ toastContainer: UIView, completion: (() -> Void)?) {
    UIView.animate(
      withDuration: self.fadeInDuration,
      delay: 0,
      options: [.allowUserInteraction, .transitionCrossDissolve],
      animations: { [weak self] in
        guard let self = self else {
          return
        }
        toastContainer.alpha = 1.0
        self.isToastShowing = true
      },
      completion: { [weak self] _ in
        guard let self = self else {
          return
        }
        UIView.animate(
          withDuration: self.fadeOutDuration,
          delay: self.delayBeforeFadeOut,
          options: [.allowUserInteraction, .transitionCrossDissolve],
          animations: {
            toastContainer.alpha = 0.0
          },
          completion: { _ in
            toastContainer.removeFromSuperview()
            self.isToastShowing = false
            completion?()
          }
        )
      }
    )
  }
}
