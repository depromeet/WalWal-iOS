//
//  AuthViewController.swift
//
//  Auth
//
//  Created by Jiyeon
//

import UIKit

import ReactorKit
import RxSwift

public protocol AuthViewController: UIViewController, View {
  
  associatedtype AuthReactorType: AuthReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bind(reactor: AuthReactorType)
  func bindAction(reactor: AuthReactorType)
  func bindState(reactor: AuthReactorType)
  func bindEvent()
}
