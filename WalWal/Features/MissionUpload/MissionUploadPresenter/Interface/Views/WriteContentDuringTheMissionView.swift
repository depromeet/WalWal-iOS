//
//  WriteContentDuringTheMissionView.swift
//  MissionUploadPresenter
//
//  Created by 조용인 on 8/21/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//


import UIKit

import ReactorKit
import RxSwift

public protocol WriteContentDuringTheMissionView: UIViewController {
  
  associatedtype WriteContentDuringTheMissionReactorType: WriteContentDuringTheMissionReactor
  var disposeBag: DisposeBag { get set }
  
  func configureLayout()
  func configureAttribute()
  func bindAction(reactor: WriteContentDuringTheMissionReactorType)
  func bindState(reactor: WriteContentDuringTheMissionReactorType)
  func bindEvent()
}
