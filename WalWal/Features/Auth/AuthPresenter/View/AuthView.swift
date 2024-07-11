//
//  AuthViewController.swift
//
//  Auth
//
//  Created by 조용인
//

import UIKit

import ReactorKit
import Then
import PinLayout
import FlexLayout
import AuthReactor


final public class AuthViewController: UIViewController {
  public var disposeBag = DisposeBag()
  
  // MARK: UI
  
  // MARK: - View LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setAttribute()
    setLayout()
  }
  
  // MARK: - Layout
  
  private func setAttribute() {
    
  }
  
  private func setLayout() {
    
  }
  
}

extension AuthViewController: View {
  
  public func bind(reactor: AuthReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  private func bindAction(reactor: AuthReactor) {
    
  }
  
  private func bindState(reactor: AuthReactor) {
    
  }
  
  private func bindEvent() {
    
  }
  
}
