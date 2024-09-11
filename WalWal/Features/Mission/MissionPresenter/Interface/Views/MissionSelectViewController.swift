//
//  MissionRecordSelectView.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 9/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

public protocol MissionSelectViewController: UIViewController {
  
  associatedtype MissionSelectReactorType: MissionSelectReactor
  var disposeBag: DisposeBag { get set }
  
  func configureLayout()
  func configureAttribute()
  func bindAction(reactor: MissionSelectReactorType)
  func bindState(reactor: MissionSelectReactorType)
  func bindEvent()
}
