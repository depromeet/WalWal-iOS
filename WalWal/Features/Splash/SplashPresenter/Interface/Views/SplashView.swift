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

public protocol SplashViewController: UIViewController, View {
  
  associatedtype SplashReactorType: SplashReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: SplashReactorType)
  func bindState(reactor: SplashReactorType)
  func bindEvent()
}
