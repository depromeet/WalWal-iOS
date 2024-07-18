//
//  OnboardingViewController.swift
//
//  Onboarding
//
//  Created by Jiyeon
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
