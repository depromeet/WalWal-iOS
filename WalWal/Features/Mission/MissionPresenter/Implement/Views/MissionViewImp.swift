//
//  MissionViewControllerImp.swift
//
//  Mission
//
//  Created by 이지희
//


import UIKit
import MissionPresenter
import MissionDomain
import Utility
import ResourceKit
import DesignSystem

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa
import Kingfisher

public final class MissionViewControllerImp<R: MissionReactor>: UIViewController, MissionViewController {
  
  private typealias Images = ResourceKitAsset.Assets
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let todayMissionLabel = UILabel().then {
    $0.text = "오늘의 미션"
    $0.textColor = Colors.walwalOrange.color
    $0.font = Fonts.KR.H6.B
  }
  private let titleLabel = UILabel().then {
    $0.font = Fonts.KR.H2
    $0.textColor = Colors.black.color
    $0.text = "반려동물과 함께\n산책한 사진을 찍어요"
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  private let missionImageView = UIImageView().then {
    $0.image = ResourceKitAsset.Sample.missionSample.image
    $0.contentMode = .scaleAspectFit
  }
  private lazy var missionCountBubbleView = BubbleView(
    color: Colors.gray150.color,
    image: Images.missionStartIcon.image,
    text: "\(missionCount)번째 미션을 수행해볼까요?"
  )
  private let missionStartButton = UIButton().then {
    $0.backgroundColor = Colors.walwalOrange.color
    $0.setTitle("미션 시작하기", for: .normal)
  }
  
  // MARK: - Properties
  
  private let missionCount = 12
  
  public var disposeBag = DisposeBag()
  public var missionReactor: R
  
  // MARK: - Initialize
  
  public init(reactor: R) {
    self.missionReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureAttribute()
    configureLayout()
    self.reactor = missionReactor
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
  }
  
  public func configureAttribute() {
    view.backgroundColor = Colors.white.color
    view.addSubview(rootContainer)
  }
  
  public func configureLayout() {
    rootContainer.flex
      .paddingTop(80.adjusted)
      .define {
        $0.addItem(todayMissionLabel)
          .alignSelf(.center)
        $0.addItem(titleLabel)
          .marginTop(14.adjusted)
          .marginHorizontal(20.adjusted)
        $0.addItem(missionImageView)
          .marginTop(14.adjusted)
          .marginHorizontal(0)
          .height(330.adjusted)
        $0.addItem()
          .direction(.columnReverse)
          .marginTop(17.adjusted)
          .define {
            $0.addItem(missionStartButton)
              .marginHorizontal(20.adjusted)
              .height(50.adjusted)
            $0.addItem(missionCountBubbleView)
              .marginBottom(-2.adjusted)
              .alignSelf(.center)
          }
      }
  }
  
  // MARK: - Method
  
  private func setMissionData(_ model: MissionModel) {
    titleLabel.text = model.title
    // TODO: 이미지 넣기
    //    if let imageUrl = URL(string: model.imageUrl) {
    //      missionImageView.kf.setImage(with: imageUrl)
    //    } else {
    //      missionImageView.image = Assets.sampleImage.image
    //    }
  }
}

extension MissionViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    reactor.action
      .onNext(.loadMission)
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.mission }
      .subscribe(with: self, onNext: { owner, mission in
        if let mission = mission {
          owner.setMissionData(mission)
        }
      })
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    
  }
}
