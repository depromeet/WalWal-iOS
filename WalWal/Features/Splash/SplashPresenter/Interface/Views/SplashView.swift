//
//  SplashViewController.swift
//
//  Splash
//
//  Created by 조용인
//

import UIKit

import ReactorKit
import RxSwift

public protocol SplashViewController: UIViewController {
  
  associatedtype SplashReactorType: SplashReactor
  var disposeBag: DisposeBag { get set }
  
  func configureLayout()
  func configureAttribute()
  func bindAction(reactor: SplashReactorType)
  func bindState(reactor: SplashReactorType)
  func bindEvent()
}
