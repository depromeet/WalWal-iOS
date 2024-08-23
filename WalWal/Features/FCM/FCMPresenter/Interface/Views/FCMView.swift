//
//  FCMViewController.swift
//
//  FCM
//
//  Created by 이지희
//

import UIKit

import ReactorKit
import RxSwift

public protocol FCMViewController: UIViewController {
  
  associatedtype FCMReactorType: FCMReactor
  var disposeBag: DisposeBag { get set }
  
  func setupLayout()
  func setupAttribute()
  func bindAction(reactor: FCMReactorType)
  func bindState(reactor: FCMReactorType)
  func bindEvent()
}
