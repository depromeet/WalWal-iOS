//
//  SampleView.swift
//  SamplePresenter
//
//  Created by 조용인 on 7/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

public protocol SampleViewController: UIViewController {
  
  associatedtype SampleReactorType: SampleReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: SampleReactorType)
  func bindState(reactor: SampleReactorType)
  func bindEvent()
}
