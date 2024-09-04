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
  
  public var disposeBag = DisposeBag()
  public var fcmReactor: R
  private lazy var datasource: RxCollectionViewSectionedReloadDataSource<FCMSectionModel> = configureDataSource()
  
  // MARK: - UI
  
  private let rootContainerView = UIView().then {
    $0.backgroundColor = Colors.gray100.color
  }
  private let naviagationBar = WalWalNavigationBar(leftItems: [], title: "알림", rightItems: []).then {
    $0.backgroundColor = Colors.white.color
  }
  private let seperator = UIView().then {
    $0.backgroundColor = Colors.gray150.color
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero, 
    collectionViewLayout: collectionViewLayout()
  ).then {
    $0.backgroundColor = Colors.gray100.color
    $0.register(FCMCollectionViewCell.self)
//    $0.registerHeader(FCMCollectionViewHeader.self)
    $0.register(FCMCollectionViewHeader.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: FCMCollectionViewHeader.reuseIdentifier)
    $0.showsVerticalScrollIndicator = false
    $0.delegate = self
  }
  
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
        $0.addItem(seperator)
          .width(100%)
          .height(1)
        $0.addItem(collectionView)
          .marginTop(13.adjustedHeight)
          .width(100%)
          .grow(1)
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
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 64)
        
    return layout
  }
  
  private func configureDataSource() -> RxCollectionViewSectionedReloadDataSource<FCMSectionModel> {
    
    return RxCollectionViewSectionedReloadDataSource { datasource, collectionView, indexPath, item in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: FCMCollectionViewCell.reuseIdentifier,
        for: indexPath
      ) as? FCMCollectionViewCell else {
        return UICollectionViewCell()
      }
      
      cell.configureCell(items: item)
      
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
    if section == 0 || fcmReactor.currentState.listData[1].items.isEmpty {
      return CGSize.zero
    } else {
      return CGSize(width: collectionView.bounds.width, height: 64)
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
    
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.listData }
      .observe(on: MainScheduler.instance)
      .bind(to: collectionView.rx.items(dataSource: datasource))
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    
  }
  
}

