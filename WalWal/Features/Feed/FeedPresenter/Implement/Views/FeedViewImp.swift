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
  
  private let guideLabel = UILabel().then {
    $0.font = Fonts.KR.H6.B
    $0.textColor = .black
    $0.text = "☀️ 다른 반려동물은 어떤 미션을 했을까요?"
  }
  
  private let arrowIconImageView = UIImageView().then {
    $0.image = Images.arrow.image
  }
  
  private lazy var feed = WalWalFeed(feedData: dummyData, isFeed: true)
  
  // MARK: - Properties
  
  public var disposeBag = DisposeBag()
  public var feedReactor: R
  private let dummyData: [WalWalFeedModel] = [
    .init(isFeedCell: true,
          date: "", nickname: "멍", missionTitle: "산책미션을 완료했어요", profileImage: ResourceKitAsset.Sample.initialProfile.image,
          missionImage: ResourceKitAsset.Sample.feedSample.image, boostCount: 123)
  ]
  
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
      .paddingTop(31)
      .define {
        $0.addItem(guideLabel)
          .alignSelf(.center)
        $0.addItem(arrowIconImageView)
        
          .alignSelf(.center)
          .marginTop(14)
          .size(24)
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
    
  }
  
  public func bindEvent() {
    
  }
}
