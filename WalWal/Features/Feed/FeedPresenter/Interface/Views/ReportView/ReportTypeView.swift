//
//  ReportTypeView.swift
//  FeedPresenter
//
//  Created by Jiyeon on 10/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

public protocol ReportTypeViewController: UIViewController {
  
  associatedtype ReportTypeReactorType: ReportTypeReactor
  var disposeBag: DisposeBag { get set }
  
  func configureLayout()
  func configureAttribute()
  func bindAction(reactor: ReportTypeReactorType)
  func bindState(reactor: ReportTypeReactorType)
  func bindEvent()
}

