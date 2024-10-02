//
//  ReportDetailView.swift
//  FeedPresenter
//
//  Created by Jiyeon on 10/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

public protocol ReportDetailViewController: UIViewController {
  
  associatedtype ReportDetailReactorType: ReportDetailReactor
  var disposeBag: DisposeBag { get set }
  
  func configureLayout()
  func configureAttribute()
  func bindAction(reactor: ReportDetailReactorType)
  func bindState(reactor: ReportDetailReactorType)
  func bindEvent()
}
