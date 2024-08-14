//
//  FCMViewController.swift
//
//  FCM
//
//  Created by Jiyeon
//

import UIKit

import ReactorKit
import RxSwift

public protocol FCMViewController: UIViewController {
  
  associatedtype FCMReactorType: FCMReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: FCMReactorType)
  func bindState(reactor: FCMReactorType)
  func bindEvent()
}
