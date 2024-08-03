//
//  ProfileSettingView.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/3/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

public protocol ProfileSettingViewController {
  
  associatedtype ProfileSettingReactorType: ProfileSettingReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: ProfileSettingReactorType)
  func bindState(reactor: ProfileSettingReactorType)
  func bindEvent()
}
