//
//  MissionViewController.swift
//
//  Mission
//
//  Created by 이지희
//

import UIKit

import ReactorKit
import RxSwift

public protocol MissionViewController: UIViewController {
  
  associatedtype MissionReactorType: MissionReactor
  var disposeBag: DisposeBag { get set }
  
  func configureLayout()
  func configureAttribute()
  func bindAction(reactor: MissionReactorType)
  func bindState(reactor: MissionReactorType)
  func bindEvent()
}
