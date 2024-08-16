//
//  RecordsViewController.swift
//
//  Records
//
//  Created by 조용인
//

import UIKit

import ReactorKit
import RxSwift

public protocol RecordsViewController: UIViewController {
  
  associatedtype RecordsReactorType: RecordsReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: RecordsReactorType)
  func bindState(reactor: RecordsReactorType)
  func bindEvent()
}
