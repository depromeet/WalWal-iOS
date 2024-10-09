//
//  SplashViewControllerImp.swift
//
//  Splash
//
//  Created by 조용인
//


import UIKit
import SplashPresenter
import ResourceKit
import Utility
import DesignSystem

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class SplashViewControllerImp<R: SplashReactor>: UIViewController, SplashViewController {
  
  private typealias Color = ResourceKitAsset.Colors
  private typealias Font = ResourceKitFontFamily.KR
  private typealias Image = ResourceKitAsset.Images
  
  public var disposeBag = DisposeBag()
  public var splashReactor: R
  
  // MARK: UI
  
  private let rootContainer = UIView()
  private let contentContainer = UIView()
  private let splashImageView = UIImageView().then {
    $0.backgroundColor = .clear
    $0.image = Image.splash.image
    $0.contentMode = .scaleAspectFit
  }
  
  // MARK: - Initialize
  
  public init(
      reactor: R
  ) {
    self.splashReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureAttribute()
    configureLayout()
    self.reactor = splashReactor
  }
  
  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
  }
  
  // MARK: - Methods
  
  public func configureAttribute() {
    view.backgroundColor = Color.walwalOrange.color
    view.addSubview(rootContainer)
    [splashImageView].forEach {
      contentContainer.addSubview($0)
    }
  }
  
  public func configureLayout() {
    rootContainer.flex
      .justifyContent(.center)
      .define {
        $0.addItem(contentContainer)
          .justifyContent(.center)
          .alignItems(.center)
          .grow(1)
      }
    splashImageView.flex
      .width(100%)
      .height(100%)
  }
}

extension SplashViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    Observable<SplashReactorAction>
      .just(Reactor.Action.checkToken)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    Observable.combineLatest(
      WalWalAlert.shared.resultRelay,
      AppUpdateManager.shared.updateRequest
    )
    .map { $0.1 }
    .distinctUntilChanged()
    .filter { $0 }
    .map { _ in Reactor.Action.moveUpdate }
    .bind(to: reactor.action)
    .disposed(by: disposeBag)
      
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.url }
      .asDriver(onErrorJustReturn: nil)
      .compactMap { $0 }
      .drive(with: self) { owner, url in
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    AppUpdateManager.shared.updateRequest
      .bind(with: self) { owner, _ in
        owner.showAlert()
      }
      .disposed(by: disposeBag)
  }
  
  private func showAlert() {
    let title = "신규 기능 업데이트"
    let message = "왈왈에서 더 재밌게 소통할 수 있도록\n신규 기능을 업데이트 해보세요!"
    let buttonTitle = "업데이트"
    
    WalWalAlert.shared.showOkAlert(
      title: title,
      bodyMessage: message,
      okTitle: buttonTitle
    )
  }
}
