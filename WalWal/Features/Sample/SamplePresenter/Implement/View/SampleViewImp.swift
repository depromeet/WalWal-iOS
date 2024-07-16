//
//  SampleViewController.swift
//
//  Sample
//
//  Created by 조용인
//

import UIKit
import SamplePresenter

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class SampleViewControllerImp<R: SampleReactor>: UIViewController, SampleViewController {
  
  public var disposeBag = DisposeBag()
  public var reactor: R?
  
  public init(
    reactor: R
  ) {
    self.reactor = reactor
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
    if let reactor = reactor { bind(reactor: reactor) }
  }
  
  
  public func setAttribute() {
    
  }
  
  public func setLayout() {
    
  }
  
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


