//
//  FCMViewControllerImp.swift
//
//  FCM
//
//  Created by 이지희
//


import UIKit
import FCMPresenter
import DesignSystem
import ResourceKit
import FCMDomain

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

public final class FCMViewControllerImp<R: FCMReactor>: 
  UIViewController, 
    FCMViewController,
  UICollectionViewDelegateFlowLayout {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - Properties
  
  public var disposeBag = DisposeBag()
  public var fcmReactor: R
  private lazy var datasource: RxCollectionViewSectionedReloadDataSource<FCMSection> = configureDataSource()
  private var isLastPage = BehaviorRelay<Bool>(value: false)
  private var nextCursor = BehaviorRelay<String?>(value: nil)
  
  // MARK: - UI
  
  private let rootContainerView = UIView().then {
    $0.backgroundColor = Colors.gray100.color
  }
  private let naviagationBar = WalWalNavigationBar(leftItems: [], title: "알림", rightItems: []).then {
    $0.backgroundColor = Colors.white.color
  }
  private let separator = UIView().then {
    $0.backgroundColor = Colors.gray150.color
  }
  
  private let walwalIndicator = WalWalRefreshControl(frame: .zero)
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.register(FCMCollectionViewCell.self)
    $0.registerHeader(FCMCollectionViewHeader.self)
    $0.showsVerticalScrollIndicator = false
    $0.delegate = self
    $0.refreshControl = walwalIndicator
  }
  private let edgeView = FCMEdgeView()
  
  public init(
    reactor: R
  ) {
    self.fcmReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupAttribute()
    setupLayout()
    self.reactor = fcmReactor
  }
  
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainerView.pin
      .vertically(view.pin.safeArea)
      .horizontally()
    
    rootContainerView.flex
      .layout()
  }
  
  public func setupAttribute() {
    view.backgroundColor = Colors.white.color
    view.addSubview(rootContainerView)
  }
  
  public func setupLayout() {
    rootContainerView.flex
      .define {
        $0.addItem(naviagationBar)
          .height(60)
        $0.addItem(separator)
          .width(100%)
          .height(1)
        $0.addItem(edgeView)
          .marginTop(204.adjustedHeight)
          .width(100%)
          .grow(1)
        $0.addItem(collectionView)
          .position(.absolute)
          .top(61 + 13.adjustedHeight)
          .width(100%)
          .bottom(0)
      }
  }
  
  private func collectionViewLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.itemSize = CGSize(
      width: UIScreen.main.bounds.width,
      height: 74.adjustedHeight
    )
    layout.scrollDirection = .vertical
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 64.adjustedHeight)
    
    return layout
  }
  
  private func configureDataSource() -> RxCollectionViewSectionedReloadDataSource<FCMSection> {
    
    return RxCollectionViewSectionedReloadDataSource<FCMSection> { datasource, collectionView, indexPath, item in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: FCMCollectionViewCell.reuseIdentifier,
        for: indexPath
      ) as? FCMCollectionViewCell else {
        return UICollectionViewCell()
      }
      switch item {
      case let .fcmItems(reactor):
        cell.reactor = reactor
      }
      return cell
      
    } configureSupplementaryView: { datasource, collectionView, kind, indexPath in
      switch kind {
      case UICollectionView.elementKindSectionHeader:
        guard let header = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: FCMCollectionViewHeader.reuseIdentifier,
          for: indexPath
        ) as? FCMCollectionViewHeader else {
          return UICollectionReusableView()
        }
        return header
      default:
        return UICollectionReusableView()
      }
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let existEmptySection = fcmReactor.currentState.listData[1].items.isEmpty || fcmReactor.currentState.listData[0].items.isEmpty
    if section == 0 || existEmptySection  {
      return CGSize.zero
    } else {
      return CGSize(width: collectionView.bounds.width, height: 64.adjustedHeight)
    }
  }
}

extension FCMViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    let modelSelected = collectionView.rx.modelSelected(FCMItems.self)
      .map {
        switch $0 {
        case let .fcmItems(reactor):
          return reactor
        }
      }
    
    walwalIndicator.rx.controlEvent(.valueChanged)
      .map { Reactor.Action.refreshList }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    modelSelected
      .map { Reactor.Action.selectItem(item: $0.currentState) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    Observable.zip(modelSelected, collectionView.rx.itemSelected)
      .filter { !$0.0.currentState.isRead }
      .map { Reactor.Action.updateItem(index: $0.1) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    collectionView.rx.reachedBottom
      .filter { _ in
        !self.isLastPage.value
      }
      .map { _ in
        Reactor.Action.loadFCMList(cursor: self.nextCursor.value, limit: 10)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
  }
  
  public func bindState(reactor: R) {
    reactor.pulse(\.$listData)
      .observe(on: MainScheduler.instance)
      .bind(to: collectionView.rx.items(dataSource: datasource))
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$stopRefreshControl)
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { owner, _ in
        owner.walwalIndicator.endRefreshing()
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isLastPage }
      .distinctUntilChanged()
      .bind(to: isLastPage)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.nextCursor }
      .distinctUntilChanged()
      .bind(to: nextCursor)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isHiddenEdgePage }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { owner, isHidden in
        owner.edgeView.isHidden = isHidden
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map{ $0.isDoubleTap }
      .distinctUntilChanged()
      .filter { $0 } // 여기서 true인 값만 거르고
      .observe(on: MainScheduler.instance)
      .subscribe(with: self, onNext: { owner, isTapped in
        owner.collectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .init(rawValue: 0), animated: true) // true인 경우에는 상단 이동
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.showIndicator }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { owner, isShow in
        ActivityIndicator.shared.showIndicator.accept(isShow)
      }
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    
  }
  
}

extension Reactive where Base: UIScrollView {
  
  // 스크롤이 바닥에 도달했을 때의 이벤트를 방출하는 Observable
  var reachedBottom: Observable<Bool> {
    return self.contentOffset
      .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .map { [weak base] _ in
        guard let scrollView = base else { return false }
        return scrollView.isNearBottom()
      }
      .filter { $0 } // true일 때만 방출
  }
}
