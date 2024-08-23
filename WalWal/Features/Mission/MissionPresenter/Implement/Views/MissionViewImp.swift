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
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private var contentView = UIView()
  private let missionStartView = MissionStartView(
    missionTitle: "반려동물과 함께\n산책한 사진을 찍어요",
    missionImage: ResourceKitAsset.Sample.missionSample.image
  )
  private let missionSucessView = MissionCompleteView()
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
  private var isLoading: Bool = true
  
  public var disposeBag = DisposeBag()
  public var missionReactor: R
  
  // MARK: - Initialize
  
  public init(reactor: R) {
    contentView = missionStartView
    self.missionReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    startAnimations()  // 애니메이션 시작
    setupNotificationObservers()  // Notification Observer 설정
  }
  
  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    stopAnimations()  // 애니메이션 중지
    removeNotificationObservers()  // Notification Observer 해제
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
    rootContainer.flex
      .paddingTop(80.adjusted)
      .define {
        $0.addItem(contentView)
          .alignSelf(.center)
        $0.addItem()
          .direction(.columnReverse)
          .marginTop(17.adjusted)
          .define {
            $0.addItem(missionStartButton)
              .marginHorizontal(20.adjusted)
            $0.addItem(missionCountBubbleView)
              .marginBottom(-8.adjusted)
              .alignSelf(.center)
          }
      }
  }
  
  // MARK: - Method
  
  private func setMissionData(_ model: MissionModel) {
    self.missionStartView.configureStartView(title: model.title, missionImageURL: model.imageURL)
  }
  
  private func configureMissionCompleteView(missionImageURL: String) {
    if isLoading {
      missionSucessView.configureStartView(recordImageURL: missionImageURL)
      rootContainer.removeFromSuperview()
      contentView.removeFromSuperview()
      
      contentView = missionSucessView
      
      view.addSubview(rootContainer)
      
      rootContainer.flex
        .paddingTop(-120)
        .define {
          $0.addItem(contentView)
            .alignSelf(.center)
          $0.addItem()
            .direction(.columnReverse)
            .marginTop(17.adjusted)
            .define {
              $0.addItem(missionStartButton)
              $0.addItem(missionCountBubbleView)
                .alignSelf(.center)
            }
        }
      rootContainer.flex
        .layout()
      
      isLoading = false
    }
  }    
  
  // MARK: - Animation Control
  
  private func startAnimations() {
    missionCountBubbleView.startFloatingAnimation()
  }
  
  private func stopAnimations() {
    missionCountBubbleView.stopFloatingAnimation()
  }
  
  // MARK: - Notification Setup
  
  private func setupNotificationObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(appDidEnterBackground),
      name: UIApplication.didEnterBackgroundNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(appWillEnterForeground),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
  }
  
  private func removeNotificationObservers() {
    NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
  }
  
  // MARK: - Notification Handlers
  
  @objc private func appDidEnterBackground() {
    stopAnimations()  // 백그라운드로 진입 시 애니메이션 중지
  }
  
  @objc private func appWillEnterForeground() {
    startAnimations()  // 포어그라운드로 복귀 시 애니메이션 재개
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
      .map{ Reactor.Action.moveToMissionUpload }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    missionStartButton.rx.tapped
      .map { [weak self] in
        return Reactor.Action.startMission(self?.missionId ?? 0)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map {  $0.totalMissionCount  }
      .subscribe(with: self) { owner, count in
        owner.missionCount = count
        owner.missionCountBubbleView.missionCount.accept(count)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .observe(on: MainScheduler.instance)
      .map { $0 }
      .subscribe(with: self, onNext: { owner, state in
        
        owner.isMissionCompleted = state.isMissionStarted
        owner.missionCountBubbleView.isCompleted.accept(state.missionStatus?.statusMessage == .completed)
        owner.missionStartButton.title = state.buttonText
        if let status = state.missionStatus {
          owner.recordImageURL = status.imageUrl
          switch status.statusMessage {
          case .notCompleted:
            owner.isMissionCompleted = false
          case .inProgress:
            owner.missionStartButton.icon = Images.watchL.image
          case .completed:
            owner.configureMissionCompleteView(missionImageURL: state.missionStatus?.imageUrl ?? "")
            owner.contentView = owner.missionSucessView
            owner.isMissionCompleted = true
            owner.missionStartButton.icon = Images.calendarL.image
          }
        }
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.mission }
      .subscribe(with: self) { owner, mission in
        
        if let mission {
          owner.missionId = mission.id
          owner.setMissionData(mission)
        }
      }
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    
  }
}
