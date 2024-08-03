//
//  RecordDetailView.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

public protocol RecordDetailViewController: UIViewController {
  
  associatedtype RecordDetailReactorType: RecordDetailReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: RecordDetailReactorType)
  func bindState(reactor: RecordDetailReactorType)
  func bindEvent()
}
