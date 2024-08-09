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

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class SplashViewControllerImp<R: SplashReactor>: UIViewController, SplashViewController {
  
  private typealias Color = ResourceKitAsset.Colors
  private typealias Font = ResourceKitFontFamily.KR
  private typealias Image = ResourceKitAsset.Sample
  
  public var disposeBag = DisposeBag()
  public var splashReactor: R
  
  // MARK: UI
  
  private let rootContainer = UIView()
  private let contentContainer = UIView()
  private let splashImageView = UIImageView().then {
    $0.backgroundColor = .clear
    $0.image = Image.authImageSample.image
    $0.contentMode = .scaleAspectFit
  }
  private let titleLabel = UILabel().then {
    $0.text = "왈왈에서 매일 만나요"
    $0.textColor = Color.black.color
    $0.font = Font.H3
    $0.textAlignment = .center
  }
  private let subTitleLabel = UILabel().then {
    $0.text = "세상 모든 반려동물을 한자리에서!"
    $0.textColor = Color.gray900.color
    $0.font = Font.H7.M
    $0.textAlignment = .center
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
      .all(view.pin.safeArea)
    rootContainer.flex
      .layout()
  }
  
  // MARK: - Methods
  
  public func configureAttribute() {
    view.backgroundColor = Color.walwalOrange.color
    view.addSubview(rootContainer)
    [splashImageView, titleLabel, subTitleLabel].forEach {
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
      .marginHorizontal(40.adjusted)
    titleLabel.flex
      .marginTop(16)
      .width(100%)
    subTitleLabel.flex
      .marginTop(6)
      .width(100%)
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
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    
  }
}
