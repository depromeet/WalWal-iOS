//
//  MembersViewController.swift
//
//  Members
//
//  Created by Jiyeon
//

import UIKit

import ReactorKit
import RxSwift

public protocol MembersViewController: UIViewController {
  
  associatedtype MembersReactorType: MembersReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: MembersReactorType)
  func bindState(reactor: MembersReactorType)
  func bindEvent()
}
