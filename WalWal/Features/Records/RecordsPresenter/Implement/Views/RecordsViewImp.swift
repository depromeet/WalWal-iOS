//
//  RecordsViewControllerImp.swift
//
//  Records
//
//  Created by 조용인
//


import UIKit
import RecordsPresenter

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class RecordsViewControllerImp<R: RecordsReactor>: UIViewController, RecordsViewController {
  
  public var disposeBag = DisposeBag()
  public var __reactor: R
  
  public init(
      reactor: R
  ) {
    self.__reactor = reactor
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
    self.reactor = __reactor
  }
    
  
  public func setAttribute() {
    
  }
  
  public func setLayout() {
    
  }
}

extension RecordsViewControllerImp: View {
  
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
