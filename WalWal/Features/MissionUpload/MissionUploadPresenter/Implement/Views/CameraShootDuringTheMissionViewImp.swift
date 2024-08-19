//
//  MissionUploadViewControllerImp.swift
//
//  MissionUpload
//
//  Created by 조용인
//


import UIKit
import MissionUploadPresenter

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class MissionUploadViewControllerImp<R: CameraShootDuringTheMissionReactor>: UIViewController, CameraShootDuringTheMissionViewController {
  
  public var disposeBag = DisposeBag()
  public var cameraShootingDuringTheMissionReactor: R
  
  public init(
      reactor: R
  ) {
    self.cameraShootingDuringTheMissionReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setAttribute()
    setLayout()
    self.reactor = self.cameraShootingDuringTheMissionReactor
  }
    
  
  public func setAttribute() {
    
  }
  
  public func setLayout() {
    
  }
}

extension MissionUploadViewControllerImp: View {
  
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