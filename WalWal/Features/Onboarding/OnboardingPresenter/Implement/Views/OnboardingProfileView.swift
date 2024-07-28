//
//  OnboardingProfileView.swift
//  OnboardingPresenterImp
//
//  Created by Jiyeon on 7/24/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import OnboardingPresenter
import Utility

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class OnboardingProfileViewController<R: OnboardingReactor>:
  UIViewController,
  OnboardingViewController {
  
  public var disposeBag = DisposeBag()
  private var onboardingReactor: R
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let contentContainer = UIView()
  private let progressView = ProgressView(index: 2)
  private let titleView = UIView()
  private let titleLabel = UILabel().then {
    $0.text = "왈왈에서 사용할\n프로필을 만들어주세요"
    $0.numberOfLines = 2
    $0.font = .boldSystemFont(ofSize: 24)
    $0.textColor = .black
  }
  private let subTitleLabel = UILabel().then {
    $0.text = "반려동물 사진을 직접 추가해보세요!"
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = .gray
  }
  private var profileSelectView = ProfileSelectView(
    viewWidth: UIScreen.main.bounds.width,
    marginItems: 17
  )
  private let nicknameTextField = NicknameTextField()
  private let nextButton = CompleteButton(isEnable: false)
  
  // MARK: - Initialize
  
  public init(reactor: R) {
    self.onboardingReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setAttribute()
    setLayout()
    self.reactor = onboardingReactor
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let _ = view.pin.keyboardArea.height
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
    hideKeyboardLayout()
  }
  
  public func setAttribute() {
    view.backgroundColor = .white
    view.addSubview(rootContainer)
    [progressView, titleView, contentContainer, nextButton].forEach {
      rootContainer.addSubview($0)
    }
    [titleLabel, subTitleLabel].forEach {
      titleView.addSubview($0)
    }
  }
  
  public func setLayout() {
    rootContainer.flex
      .justifyContent(.center)
    progressView.flex
      .marginTop(32)
      .marginHorizontal(20)
    titleView.flex
      .marginHorizontal(20)
      .define {
        $0.addItem(titleLabel)
          .marginTop(48)
        $0.addItem(subTitleLabel)
          .marginTop(4)
      }
    contentContainer.flex
      .justifyContent(.start)
      .grow(1)
      .define {
        $0.addItem(profileSelectView)
          .alignItems(.center)
          .marginTop(70)
          .width(100%)
          .height(170)
        $0.addItem(nicknameTextField)
          .justifyContent(.center)
          .marginTop(32)
          .marginHorizontal(20)
      }
    nextButton.flex
      .marginHorizontal(20)
  }
  
  
  private func updateKeyboardLayout() {
    let keyboardTop = view.pin.keyboardArea.height - view.pin.safeArea.bottom
    nextButton.pin.bottom(keyboardTop + 20)
    view.layoutIfNeeded()
  }
  
  private func hideKeyboardLayout() {
    nextButton.pin.bottom(30).height(56)
  }
}

// MARK: - Binding

extension OnboardingProfileViewController {
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .bind(with: self) { owner, _ in
        owner.updateKeyboardLayout()
      }
      .disposed(by: disposeBag)
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .bind(with: self) { owner, noti in
        owner.hideKeyboardLayout()
      }
      .disposed(by: disposeBag)
    nicknameTextField.textField.rx.controlEvent(.editingDidEndOnExit)
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.nicknameTextField.textField.resignFirstResponder()
      }
      .disposed(by: disposeBag)
  }
}

extension Reactive where Base: UICollectionView {
  public func datasource<Sequence: Swift.Sequence, Cell: UICollectionViewCell, Source: ObservableType>
  (_ cellType: Cell.Type = Cell.self)
  -> (_ source: Source)
  -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
  -> Disposable where Source.Element == Sequence, Cell: ReusableView {
    return { source in
      return { configureCell in
        return source.bind(to: self.base.rx.items(
          cellIdentifier: cellType.reuseIdentifier,
          cellType: cellType)
        ) { index, data, cell in
          configureCell(index, data, cell)
        }
      }
    }
  }
}
