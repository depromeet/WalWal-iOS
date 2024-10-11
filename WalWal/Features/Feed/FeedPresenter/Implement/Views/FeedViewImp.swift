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
import Lottie

public final class FeedViewControllerImp<R: FeedReactor>: UIViewController, FeedViewController {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let feed = WalWalFeed(feedData: [], isFeed: true)
  
  private let coachView = FeedCoachMarkView()
  
  // MARK: - Properties
  
  public var disposeBag = DisposeBag()
  public var feedReactor: R
  private var checkScrollItem = PublishSubject<Void>()
  
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
    showCoachView()
    self.reactor = feedReactor
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin
      .all(view.pin.safeArea)
    rootContainer.flex
      .layout()
  }
  
  public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    feed.collectionView.collectionViewLayout.invalidateLayout()
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
  
  private func showCoachView() {
    if UserDefaults.bool(forUserDefaultsKey: .isFirstFeedAppear) {
      let scenes = UIApplication.shared.connectedScenes
      let windowScene = scenes.first as? UIWindowScene
      let window = windowScene?.windows.first
      
      
      coachView.isHidden = false
      window?.addSubview(coachView)
      coachView.pin.all()
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
    feed.scrollEndReached
      .skip(1)
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .map { _ in Reactor.Action.loadFeedData(cursor: reactor.currentState.nextCursor) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    feed.refreshLoading
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .filter { $0 }
      .map { _ in Reactor.Action.refresh(cursor: nil) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    feed.updatedBoost
      .map { reocrdId, count in
        Reactor.Action.endedBoost(recordId: reocrdId, count: count)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    feed.profileTapped
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { Reactor.Action.profileTapped($0) }
      .bind(to: reactor.action )
      .disposed(by: disposeBag)
    
    feed.menuButtonTapped
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .map { Reactor.Action.menuTapped(recordId: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    feed.commentButtonTapped
      .throttle(.microseconds(300), scheduler: MainScheduler.instance)
      .map { Reactor.Action.commentTapped(recordId: $0.recordId, writerNickname: $0.writerNickname) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    checkScrollItem
      .observe(on: MainScheduler.asyncInstance)
      .map { Reactor.Action.checkScrollItem }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map {  $0.feedData }
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(with: self, onNext: { owner, feed in
        guard owner.feed.feedData.value != feed else { return }
        owner.feed.addNewData(feed)
        owner.checkScrollItem.onNext(())
      })
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$scrollToFeedItem)
      .asDriver(onErrorJustReturn: nil)
      .compactMap { $0 }
      .drive(with: self) { owner, recordId in
        owner.feed.scrollToRecord(withId: recordId, animated: true)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map{ $0.isDoubleTap }
      .distinctUntilChanged()
      .filter { $0 }
      .observe(on: MainScheduler.instance)
      .subscribe(with: self, onNext: { owner, isTapped in
        owner.feed.collectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .init(rawValue: 0), animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    
  }
}
