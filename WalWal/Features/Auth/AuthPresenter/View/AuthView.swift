//
//  AuthViewController.swift
//
//  Auth
//
//  Created by Jiyeon
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
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
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
