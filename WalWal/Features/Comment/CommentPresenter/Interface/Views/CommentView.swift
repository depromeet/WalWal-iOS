//
//  CommentViewController.swift
//
//  Comment
//
//  Created by 조용인
//

import UIKit

import ReactorKit
import RxSwift

public protocol CommentViewController: UIViewController {
  
  associatedtype CommentReactorType: CommentReactor
  var disposeBag: DisposeBag { get set }
  
  func setLayout()
  func setAttribute()
  func bindAction(reactor: CommentReactorType)
  func bindState(reactor: CommentReactorType)
  func bindEvent()
}
