//
//  FeedViewControllerImp.swift
//
//  Feed
//
//  Created by 이지희
//


import UIKit
import FeedPresenter
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class FeedViewControllerImp<R: FeedReactor>: UIViewController, FeedViewController {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private lazy var feed = WalWalFeed(feedData: dummyData, isFeed: true)
  
  // MARK: - Properties
  
  public var disposeBag = DisposeBag()
  public var feedReactor: R
  private let dummyData: [WalWalFeedModel] = []
  
  // MARK: - Initialize
  
  public init(
    reactor: R
  ) {
    self.feedReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureLayout()
    configureAttribute()
    self.reactor = feedReactor
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin
      .all(view.pin.safeArea)
    rootContainer.flex
      .layout()
  }
  
  // MARK: - Layout
  
  public func configureAttribute() {
    view.backgroundColor = Colors.gray150.color
    view.addSubview(rootContainer)
  }
  
  public func configureLayout() {
    rootContainer.flex
      .define {
        $0.addItem(feed)
          .grow(1)
      }
  }
}

extension FeedViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    
  }
  
  public func bindState(reactor: R) {
    reactor.action
      .onNext(.loadFeedData(cursor: "2024-01-01", limits: 10))
  }
  
  public func bindEvent() {
    
  }
}
