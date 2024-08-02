//
//  MyPageViewController.swift
//
//  MyPage
//
//  Created by 조용인
//

import UIKit

import ReactorKit
import RxSwift

public protocol MyPageViewController: UIViewController {
  
  associatedtype MyPageReactorType: MyPageReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: MyPageReactorType)
  func bindState(reactor: MyPageReactorType)
  func bindEvent()
}
