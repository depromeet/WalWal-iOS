//
//  WalWalFeed.swift
//  DesignSystem
//
//  Created by 이지희 on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public final class WalWalFeed: UIView {
  
  public var feedData = PublishRelay<[WalWalFeedModel]>()
  
  private let disposeBag = DisposeBag()
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: 342, height: 470)
    flowLayout.minimumLineSpacing = 14
    
    $0.collectionViewLayout = flowLayout
    $0.register(WalWalFeedCell.self, forCellWithReuseIdentifier: "WalWalFeedCell")
  }
  
  // MARK: - Initializers
  public override init(frame: CGRect) {
    super.init(frame: frame)
    configureCollectionView()
    setAttributes()
    setLayouts()
    bindFeedData()
  }
  
  public init(feedData: [WalWalFeedModel]) {
    super.init(frame: .zero)
    configureCollectionView()
    setAttributes()
    setLayouts()
    bindFeedData()
    self.feedData.accept(feedData)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  public override func layoutSubviews() {
    super.layoutSubviews()
    flex.layout()
  }
  
  // MARK: - Methods
  private func setAttributes() {
    
  }
  
  private func setLayouts() {
    flex.define { flex in
      flex.addItem(collectionView)
        .grow(1)
    }
  }
  
  private func configureCollectionView() {
    // Configure the collection view layout here if needed
  }
  
  private func bindFeedData() {
    feedData
      .bind(to: collectionView.rx.items(cellIdentifier: "WalWalFeedCell", cellType: WalWalFeedCell.self)) { index, model, cell in
        cell.configureCell(feedData: model)
      }
      .disposed(by: disposeBag)
  }
}
