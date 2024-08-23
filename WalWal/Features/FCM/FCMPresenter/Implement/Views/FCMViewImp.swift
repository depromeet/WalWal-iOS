//
//  FCMViewControllerImp.swift
//
//  FCM
//
//  Created by 이지희
//


import UIKit
import FCMPresenter

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class FCMViewControllerImp<R: FCMReactor>: UIViewController, FCMViewController {
  
  public var disposeBag = DisposeBag()
  public var fcmReactor: R
  
  public init(
      reactor: R
  ) {
    self.fcmReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupAttribute()
    setupLayout()
    self.reactor = fcmReactor
  }
    
  
  public func setupAttribute() {
    
  }
  
  public func setupLayout() {
    
  }
}

extension FCMViewControllerImp: View {
  
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
  
  public func bindEvent() {
    
  }
}
