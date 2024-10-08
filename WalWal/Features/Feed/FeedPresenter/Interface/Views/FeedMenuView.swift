//
//  FeedMenuView.swift
//  FeedPresenter
//
//  Created by Jiyeon on 10/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

public protocol FeedMenuViewController: UIViewController {
  
  associatedtype FeedMenuReactorType: FeedMenuReactor
  var disposeBag: DisposeBag { get set }
  
  func configureLayout()
  func configureAttribute()
  func bindAction(reactor: FeedMenuReactorType)
  func bindState(reactor: FeedMenuReactorType)
  func bindEvent()
}
