//
//  SampleViewController.swift
//
//  Sample
//
//  Created by 조용인
//

import UIKit
import SamplePresenterReactor

import Then
import PinLayout
import FlexLayout
import RxSwift
import RxCocoa
import ReactorKit

final public class SampleViewController: UIViewController {
  
  // MARK: - Properties
  
  public var disposeBag = DisposeBag()
  
  // MARK: - UI
  
  // MARK: - View LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setAttribute()
    setLayout()
  }
  
  // MARK: - Layout
  
  private func setAttribute() {
    
  }
  
  private func setLayout() {
    
  }
  
}

extension SampleViewController: View {
  
  public func bind(reactor: SampleReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  private func bindAction(reactor: SampleReactor) {
    
  }
  
  private func bindState(reactor: SampleReactor) {
    
  }
  
  private func bindEvent() {
    
  }
  
}
