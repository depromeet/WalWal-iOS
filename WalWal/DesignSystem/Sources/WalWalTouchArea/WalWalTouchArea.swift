//
//  WalWalTouchArea.swift
//  DesignSystem
//
//  Created by 조용인 on 7/29/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout
import Then

public final class WalWalTouchArea: UIView {
  
  private let containerView = UIView()
  
  public enum TouchAreaState: Int, CaseIterable {
    case normal = 0
    case selected = 1
  }
  
  // MARK: - UI
  
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  // MARK: - Properties
  
  /// 현재 TouchArea의 상태를 가지고 있는 스트림
  public private(set) var state = BehaviorRelay<TouchAreaState>(value: .normal)
  
  private let disposeBag = DisposeBag()
  
  private var images: [TouchAreaState: UIImage] = [:]
  
  // MARK: - Initializers
  
  /// WalWalTouchArea를 초기화합니다.
  ///
  /// - Parameters
  ///   - image: 기본 이미지. nil이면 빈 이미지가 설정됩니다.
  ///   - size: TouchArea의 사이즈 (default: 24)
  public init(
    image: UIImage? = nil,
    size: CGFloat = 24
  ) {
    super.init(frame: .zero)
    
    configureAttributes(image: image)
    configureLayout(size: size)
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  
  /// 특정 state에 따른 image를 설정합니다.
  /// - Parameters:
  ///   - image: 설정할 이미지
  ///   - state: 이미지를 적용할 상태
  public func setImage(_ image: UIImage?, for state: TouchAreaState) {
    images[state] = image
    if self.state.value == state {
      imageView.image = image
    }
  }
  
  // MARK: - Lifecycle
  
  public override func layoutSubviews() {
    super.layoutSubviews()

    containerView.pin
      .all()
    containerView.flex
      .layout()
  }
}

// MARK: - Private Methods

private extension WalWalTouchArea {
  func configureAttributes(image: UIImage?) {
    TouchAreaState.allCases.forEach { setImage(image, for: $0) }
  }
  
  func configureLayout(size: CGFloat) {
    addSubview(containerView)
    
    containerView.flex
      .alignItems(.center)
      .justifyContent(.center)
      .define { flex in
        flex.addItem(imageView)
          .width(size)
          .height(size)
      }
  }
  
  func bind() {
    state
      .subscribe(with: self, onNext: { owner, state in
        owner.imageView.image = owner.images[state]
      })
      .disposed(by: disposeBag)
    
    rx.tapped
      .subscribe(with: self, onNext: { owner, _ in
        owner.state.accept(owner.state.value == .normal ? .selected : .normal)
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - Reactive Extension

public extension Reactive where Base: WalWalTouchArea {
  var tapped: ControlEvent<Void> {
    ControlEvent(events: base.rx.tapGesture().when(.recognized).map { _ in })
  }
}
