//
//  ProfileEditView.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

public protocol ProfileEditViewController: UIViewController {
  
  associatedtype ProfileEditReactorType: ProfileEditReactor
  var disposeBag: DisposeBag { get set }
  
  func configureLayout()
  func configureAttribute()
  func bindAction(reactor: ProfileEditReactorType)
  func bindState(reactor: ProfileEditReactorType)
  func bindEvent()
}
