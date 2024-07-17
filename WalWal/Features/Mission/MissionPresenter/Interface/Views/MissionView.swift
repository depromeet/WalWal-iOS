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

public protocol MissionViewController: UIViewController, View {
  
  associatedtype MissionReactorType: MissionReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: MissionReactorType)
  func bindState(reactor: MissionReactorType)
  func bindEvent()
}
