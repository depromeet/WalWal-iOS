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

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa
import Kingfisher

public final class MissionViewControllerImp<R: MissionReactor>: UIViewController, MissionViewController {
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let missionTimerView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.3)
    $0.layer.cornerRadius = 20.adjusted
  }
  private let missionTimerImageView = UIImageView().then {
    $0.image = Assets.timerFilled.image
  }
  private let missionTimerLabel = UILabel().then {
    $0.text = "오늘의 미션"
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 14.adjusted, weight: .semibold)
  }
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 28.adjusted, weight: .bold)
    $0.textColor = .black
    $0.text = "반려동물과 함께\n산책한 사진을 찍어요"
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  private let missionImageView = UIImageView().then {
    $0.image = SampleAssets.missionSample.image
    $0.contentMode = .scaleAspectFit
  }
  private let dateLabel = UILabel().then {
    $0.text = "123일째"
    $0.font = ResourceKitFontFamily.LotteriaChab.H1
  }
  private let missionStartButton = UIButton().then {
    $0.backgroundColor = .black
    $0.setTitle("미션하러 가기", for: .normal)
  }
  
  // MARK: - Properties
  
  public var disposeBag = DisposeBag()
  public var missionReactor: R
  private typealias Assets = ResourceKitAsset.Assets
  private typealias SampleAssets = ResourceKitAsset.Sample
  
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
    setAttribute()
    setLayout()
    self.reactor = missionReactor
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
  }
  
  public func setAttribute() {
    view.backgroundColor = .lightGray
    view.addSubview(rootContainer)
    
    [missionTimerImageView, missionTimerLabel].forEach {
      missionTimerView.addSubview($0)
    }
  }
  
  public func setLayout() {
    rootContainer.flex
      .paddingTop(40.adjusted)
      .define {
        $0.addItem(missionTimerView)
          .height(40.adjusted)
          .width(120.adjusted)
          .alignSelf(.center)
        $0.addItem(titleLabel)
          .marginTop(14.adjusted)
          .marginHorizontal(20.adjusted)
        $0.addItem(missionImageView)
          .marginTop(14.adjusted)
          .marginHorizontal(0)
          .height(340.adjusted)
        $0.addItem(dateLabel)
          .marginTop(7.adjusted)
          .alignSelf(.center)
        $0.addItem(missionStartButton)
          .marginTop(10.adjusted)
          .marginHorizontal(20.adjusted)
          .height(50.adjusted)
      }
    
    missionTimerView.flex
      .direction(.row)
      .justifyContent(.center)
      .alignItems(.center)
      .define {
        $0.addItem(missionTimerImageView)
          .size(24.adjusted)
        $0.addItem(missionTimerLabel)
          .marginLeft((3.5).adjusted)
      }
  }
  
  // MARK: - Method
  
  private func setMissionData(_ model: MissionModel) {
    titleLabel.text = model.title
    dateLabel.text = "\(model.date)일째"
    view.backgroundColor = UIColor(hexCode: model.backgroundColorCode)
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
      .subscribe(with: self, onNext: { weakSelf, mission in
        if let mission = mission {
          weakSelf.setMissionData(mission)
        }
      })
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    
  }
}
