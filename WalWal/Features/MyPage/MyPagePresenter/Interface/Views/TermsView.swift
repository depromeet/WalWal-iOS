//
//  TermsViewController.swift
//  MyPagePresenter
//
//  Created by Jiyeon on 8/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import RxSwift

public protocol TermsViewController: UIViewController {
  
  associatedtype TermsReactorType: TermsReactor
  var disposeBag: DisposeBag { get set }
  
  func configureLayout()
  func configureAttribute()
  func bind(reactor: TermsReactorType)
}

public enum TermsType {
  case service
  case privacy
}
