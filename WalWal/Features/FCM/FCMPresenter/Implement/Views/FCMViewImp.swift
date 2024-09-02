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

public final class FCMViewControllerImp<R: FCMReactor>: UIViewController, FCMViewController {
  
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
    $0.showsVerticalScrollIndicator = false
  }
//  private let titleLabel = UILabel().then {
//    $0.text = "앗.."
//    $0.font = Fonts.LotteriaChab.Buster_Cute
//    $0.textColor = Colors.black.color
//  }
//  private let subTitelLabel = UILabel().then {
//    $0.text = "아직 알림이 없어요!"
//    $0.font = Fonts.KR.H5.B
//    $0.textColor = Colors.black.color
//  }
//  private let guideLabel = UILabel().then {
//    $0.text = "조금만 기다리면 알림이 올 거예요."
//    $0.numberOfLines = 2
//    $0.textAlignment = .center
//    $0.font = Fonts.KR.H7.M
//    $0.textColor = Colors.black.color
//  }
//  private let actionButton = WalWalButton(type: .dark, title: "")
  
  let items: [FCMSectionModel] = [
    FCMSectionModel(section: 0, items: [
      .init(id: 1, type: .mission, title: "11", message: "11", imageURL: nil, isRead: false, recordID: 1, createdAt: "2024.08.11"),
      .init(id: 2, type: .boost, title: "22", message: "22", imageURL: nil, isRead: true, recordID: 2, createdAt: "2024.08.13"),
      .init(id: 3, type: .boost, title: "33", message: "33", imageURL: nil, isRead: false, recordID: 3, createdAt: "2024.08.14")
    ])
  ]
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
    
  }
  
  public func bindEvent() {
    
    Observable.just(items)
      .bind(to: collectionView.rx.items(dataSource: datasource))
      .disposed(by: disposeBag)
    
  }
}
