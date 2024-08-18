//
//  MissionUploadViewController.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import UIKit

import ReactorKit
import RxSwift

public protocol MissionUploadViewController: UIViewController {
  
  associatedtype MissionUploadReactorType: MissionUploadReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: MissionUploadReactorType)
  func bindState(reactor: MissionUploadReactorType)
  func bindEvent()
}
