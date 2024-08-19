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

public protocol CameraShootDuringTheMissionViewController: UIViewController {
  
  associatedtype CameraShootDuringTheMissionReactorType: CameraShootDuringTheMissionReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: CameraShootDuringTheMissionReactorType)
  func bindState(reactor: CameraShootDuringTheMissionReactorType)
  func bindEvent()
}
