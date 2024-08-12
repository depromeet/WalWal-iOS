//
//  FeedViewController.swift
//
//  Feed
//
//  Created by 이지희
//

import UIKit

import ReactorKit
import RxSwift

public protocol FeedViewController: UIViewController {
  
  associatedtype FeedReactorType: FeedReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: FeedReactorType)
  func bindState(reactor: FeedReactorType)
  func bindEvent()
}
