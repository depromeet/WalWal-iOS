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
import RecordsDomain
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
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let missionContainer = UIView()
  private let buttonContainer = UIView()
  private let bubbleContainer = UIView()
  
  private let missionStartView = MissionStartView(
    missionTitle: "반려동물과 함께\n산책한 사진을 찍어요",
    missionImage: ResourceKitAsset.Sample.missionSample.image
  )
  
  private let missionCompletedView = MissionCompleteView()
  
  private lazy var missionCountBubbleView = BubbleView()
  
  private let missionStartButton = WalWalButton_Icon(
    type: .active,
    title: "미션 시작하기",
    icon:Images.flagS.image
  )
  
  // MARK: - Properties
  
  private var missionCount: Int = 0
  private var missionId: Int = 0
  private var isMissionCompleted: Bool = false
  private var recordImageURL: String = ""
  
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
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    missionCountBubbleView.startFloatingAnimation()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureAttribute()
    configureLayout()
    
    missionCountBubbleView.startFloatingAnimation()
    self.reactor = missionReactor
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin
      .all(view.pin.safeArea)
    rootContainer.flex
      .layout()
  }
  
  public func configureAttribute() {
    view.backgroundColor = Colors.white.color
    view.addSubview(rootContainer)
  }
  
  public func configureLayout() {
    rootContainer.flex.define {
      $0.addItem(missionContainer)
        .width(100%)
        .height(450.adjusted)
        .marginTop(40.adjustedHeight)
      
      $0.addItem(buttonContainer)
        .width(100%)
        .position(.absolute)
        .bottom(30)
      
      $0.addItem(bubbleContainer)
        .width(100%)
        .height(60.adjusted)  // 버블의 예상 높이에 따라 조정
        .position(.absolute)
        .bottom(70.adjusted)  // 버튼 컨테이너 위에 위치하도록 조정
    }
    
    missionContainer.flex.define {
      $0.addItem(missionStartView)
        .position(.absolute)
        .all(0)
      
      $0.addItem(missionCompletedView)
        .position(.absolute)
        .all(0)
    }
    
    buttonContainer.flex.define {
      $0.addItem(missionStartButton)
        .marginHorizontal(20.adjusted)
    }
    
    bubbleContainer.flex.define {
      $0.addItem(missionCountBubbleView)
        .position(.absolute)
        .alignSelf(.center)
        .bottom(0)
    }
  }
  
  
  // MARK: - Method
  
  private func configureMissionProcessing(_ model: MissionModel) {
    print("미션 시작 페이지 업데이트")
    self.missionStartView.configureStartView(title: model.title, missionImageURL: model.imageURL)
  }
  
  private func configureMissionStatus(_ status: MissionRecordStatusModel) {
    switch status.statusMessage {
    case .completed:
      print("미션 완료 페이지 업데이트")
      self.missionCompletedView.configureStartView(recordImageURL: status.imageUrl)
      self.missionStartView.isHidden = true
      self.missionCompletedView.isHidden = false
    case .notCompleted, .inProgress:
      self.missionStartView.isHidden = false
      self.missionCompletedView.isHidden = true
    }
    self.missionContainer.flex.layout()
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
    
    missionStartButton.rx.tapped
      .map { Reactor.Action.moveToMissionUpload }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

  }
  
  public func bindState(reactor: R) {
    reactor.state
      .compactMap { $0.mission }
      .distinctUntilChanged()
      .compactMap { $0 }
      .subscribe(with: self, onNext: { owner, mission in
        owner.configureMissionProcessing(mission)
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.recordStatus }
      .distinctUntilChanged()
      .compactMap { $0 }
      .subscribe(with: self, onNext: { owner, status in
        owner.configureMissionStatus(status)
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.totalCompletedRecordsCount }
      .distinctUntilChanged()
      .bind(to: missionCountBubbleView.missionCount)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.loadInitialDataFlowFailed }
      .compactMap { $0 }
      .subscribe(onNext: { error in
        WalWalToast.shared.show(type: .error, message: error.localizedDescription)
      })
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    
  }
  
  
}
