//
//  OnboardingSelectView.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/31/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

public protocol OnboardingSelectViewController: UIViewController {
  associatedtype OnboardingSelectReactorType: OnboardingSelectReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: OnboardingSelectReactorType)
  func bindState(reactor: OnboardingSelectReactorType)
  func bindEvent()
}

