//
//  ProfileSettingViewImp.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/3/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//


import UIKit
import MyPagePresenter
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class ProfileSettingViewControllerImp<R: ProfileSettingReactor>: UIViewController, ProfileSettingViewController {

  public var disposeBag = DisposeBag()
  public var __reactor: R
  
  
  public init(
      reactor: R
  ) {
    self.__reactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    super.init(nibName: nil, bundle: nil)
  }
  
  public func setLayout() {
    <#code#>
  }
  
  public func setAttribute() {
    <#code#>
  }
}

extension ProfileSettingViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    
  }
}
