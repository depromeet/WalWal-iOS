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

public protocol AuthViewController: UIViewController {
  associatedtype AuthReactorType: AuthReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: AuthReactorType)
  func bindState(reactor: AuthReactorType)
  func bindEvent()
}
