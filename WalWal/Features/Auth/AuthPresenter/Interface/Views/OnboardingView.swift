//
//  OnboardingView.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/31/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

public protocol OnboardingViewController: UIViewController {
  associatedtype OnboardingReactorType: OnboardingReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: OnboardingReactorType)
  func bindState(reactor: OnboardingReactorType)
  func bindEvent()
}

