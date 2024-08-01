//
//  WalWalFeed.swift
//  DesignSystem
//
//  Created by 이지희 on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import RxSwift

public final class WalWalFeed: UIView {
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = .init(width: 342.adjusted, height: 470.adjusted)
    flowLayout.minimumLineSpacing = 4
    
    $0.collectionViewLayout = flowLayout
    $0.register(WalWalFeedCell.self, forCellWithReuseIdentifier: "WalWalFeed")
  }
  
  private var feedData: [WalWalFeedModel]
  
  // MARK: - Initializers
  
  public init(feedData: [WalWalFeedModel]) {
    self.feedData = feedData
    super.init(frame: .zero)
    configureCollectionView()
    setAttributes()
    setLayouts()
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
    self.backgroundColor = .white
  }
  
  private func setLayouts() {
    flex.define {
      $0.addItem(collectionView)
        .grow(1)
    }
  }
  
  private func configureCollectionView() {
    collectionView.dataSource = self
  }
  
}

extension WalWalFeed: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return feedData.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalWalFeed", for: indexPath) as? WalWalFeedCell
    else { return UICollectionViewCell() }
    cell.configureCell(nickName: feedData[indexPath.item].nickname,
                       missionTitle: feedData[indexPath.item].missionTitle,
                       profileImage: feedData[indexPath.item].profileImage,
                       missionImage: feedData[indexPath.item].missionImage,
                       boostCount: feedData[indexPath.item].boostCount)
    return cell
  }
  
  
}
