//
//  SplashViewControllerImp.swift
//
//  Splash
//
//  Created by 조용인
//


import UIKit
import SplashPresenter

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class SplashViewControllerImp<R: SplashReactor>: UIViewController, SplashViewController {
  
  public var disposeBag = DisposeBag()
  public var splashReactor: R
  
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
    setAttribute()
    setLayout()
    self.reactor = splashReactor
  }
  
  
  public func setAttribute() {
    
  }
  
  public func setLayout() {
    
  }
  
  public func bindEvent() {
    
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
    
  }
  
  public func bindState(reactor: R) {
    
  }
}
