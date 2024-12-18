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
  private let missionContainerWrapper = UIView()
  private let buttonContainerWrapper = UIView()
  private let bubbleContainerWrapper = UIView()
  
  private let splashContainer = UIView().then {
    $0.backgroundColor = Colors.walwalOrange.color
  }
  private let splashForLoading = UIImageView().then {
    $0.image = Images.splash.image
    $0.contentMode = .scaleAspectFit
  }
  
  private let missionContainer = UIView()
  private let missionStartView = MissionStartView(
    missionTitle: "반려동물과 함께\n산책한 사진을 찍어요",
    missionImage: ResourceKitAsset.Sample.missionSample.image
  )
  
  private let missionCompletedView = MissionCompleteView()
  
  private let buttonContainer = UIView()
  private let missionStartButton = WalWalButton_Icon(
    type: .active,
    title: "미션 시작하기",
    icon: Images.flagS.image
  )
  
  private let bubbleContainer = UIView()
  private lazy var missionCountBubbleView = BubbleView()
  private let missionMarkView = MissionCoachMarkView()
  private var permissionView: PermissionView?
  
  // MARK: - Properties
  
  private var missionCount: Int = 0
  private var missionId: Int = 0
  private var isMissionCompleted: Bool = false
  private var recordImageURL: String = ""
  
  private var recordList: [RecordList] = []
  
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
    setupNotificationObservers()
  }
  
  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    missionCountBubbleView.stopFloatingAnimation()
    removeNotificationObservers()
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
    
    bubbleContainer.flex.markDirty()
    bubbleContainer.flex.layout()
    bubbleContainerWrapper.flex.layout()
    
    rootContainer.pin
      .all(view.pin.safeArea)
    
    rootContainer.flex
      .layout()
    
    splashContainer.pin
      .all()
    splashContainer.flex
      .layout()
  }
  
  public func configureAttribute() {
    guard let window = UIWindow.key else { return }
    view.backgroundColor = UIColor(hex: 0xFAFAFA)
    view.addSubview(rootContainer)
    window.addSubview(splashContainer)
  }
  
  public func configureLayout() {
    rootContainer.flex
      .define { flex in
        flex.addItem(missionContainer)
          .width(100%)
          .grow(1)
        flex.addItem(buttonContainerWrapper)
          .width(100%)
          .position(.absolute)
          .bottom(30.adjusted)
        flex.addItem(bubbleContainerWrapper)
          .width(100%)
          .height(60.adjusted)
          .position(.absolute)
          .bottom(72.adjusted)
      }
    
    missionContainer.flex
      .define { flex in
        flex.addItem(missionStartView)
          .position(.absolute)
          .top(80)
          .alignSelf(.center)
        flex.addItem(missionCompletedView)
          .position(.absolute)
          .top(0)
          .width(100%)
          .alignSelf(.center)
      }
    
    buttonContainerWrapper.flex
      .define { flex in
        flex.addItem(buttonContainer)
          .grow(1)
      }
    
    buttonContainer.flex
      .define { flex in
        flex.addItem(missionStartButton)
          .marginHorizontal(20.adjusted)
      }
    
    bubbleContainerWrapper.flex
      .define { flex in
        flex.addItem(bubbleContainer)
          .grow(1)
      }
    
    bubbleContainer.flex
      .define { flex in
        flex.addItem(missionCountBubbleView)
          .alignSelf(.center)
          .position(.absolute)
          .bottom(0)
      }
    
    splashContainer.flex
      .define { flex in
        flex.addItem(splashForLoading)
          .grow(1)
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
      self.missionCompletedView.configureCompleteView(recordList: status.records)
      self.missionStartView.isHidden = true
      self.missionCompletedView.isHidden = false
      requestStoreReview()
    case .notCompleted, .inProgress:
      self.missionStartView.isHidden = false
      self.missionCompletedView.isHidden = true
    }
    self.missionContainer.flex.layout()
  }
  
  private func updateButtonState(for status: StatusMessage?) {
    switch status {
    case .notCompleted:
      isMissionCompleted = false
      missionStartButton.isEnabled = true
    case .inProgress:
      isMissionCompleted = false
      missionStartButton.isEnabled = true
    case .completed:
      isMissionCompleted = true
      missionStartButton.isEnabled = true /// 이후에 기록으로 이동시켜야함
    case .none:
      isMissionCompleted = false
      missionStartButton.isEnabled = false
    }
  }
  
  private func updateButtonIcon(for status: StatusMessage?) {
    switch status {
    case .notCompleted:
      missionStartButton.icon = Images.flagS.image
    case .inProgress:
      missionStartButton.icon = Images.watchS.image
    case .completed:
      missionStartButton.icon = Images.calendarS.image
    case .none:
      missionStartButton.icon = Images.flagS.image
    }
  }
  
  private func updateBubbleViewTitle(for status: StatusMessage?) {
    let isCompleted = status == .completed ? true : false
    missionCountBubbleView.isCompleted.accept(isCompleted)
    /// 버블뷰의 타이틀이 변할 때 마다 다시 계산해야 하므로 필요
    bubbleContainer.flex.markDirty()
    bubbleContainer.flex.layout()
  }
  
  private func showCoachView() {
    if UserDefaults.bool(forUserDefaultsKey: .isFirstMissionAppear) {
      let window = UIWindow.key
      missionMarkView.isHidden = false
      window?.addSubview(missionMarkView)
      missionMarkView.pin.all()
    }
  }
  
  private func requestStoreReview() {
    let missionCompletedCount = missionReactor.currentState.totalCompletedRecordsCount
    StoreReviewManager.shared.requestReview(missionCount: missionCompletedCount)
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
    missionCountBubbleView.stopFloatingAnimation()
  }
  
  @objc private func appWillEnterForeground() {
    missionCountBubbleView.startFloatingAnimation()
    missionReactor.action.onNext(.appWillEnterForeground)
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
      .map {
        if !self.isMissionCompleted {
          return Reactor.Action.moveToMissionUpload
        } else {
          return Reactor.Action.moveToMyPage
        }
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isTimerRunning }
      .distinctUntilChanged()
      .filter { $0 }
      .map { _ in Reactor.Action.startTimer }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isTimerRunning }
      .distinctUntilChanged()
      .filter { !$0 }
      .map { _ in Reactor.Action.stopTimer }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    
    PHPickerManager.shared.selectedPhotoForMission
      .asDriver(onErrorJustReturn: nil)
      .compactMap { $0 }
      .drive(with: self) { owner, image in
        reactor.action.onNext(.moveToMissionGallery(image))
      }
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
      .map { $0.loadInitialDataFlowEnded }
      .subscribe(with: self, onNext: { owner, isLoadInitialDataFlowEnded in
        owner.splashContainer.isHidden = isLoadInitialDataFlowEnded
        
        owner.showCoachView()
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.loadInitialDataFlowFailed }
      .compactMap { $0 }
      .subscribe(onNext: { error in
        WalWalToast.shared.show(type: .error, message: error.localizedDescription)
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.buttonTitle }
      .distinctUntilChanged()
      .bind(to: missionStartButton.rx.title)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.recordStatus?.statusMessage }
      .distinctUntilChanged()
      .subscribe(with: self, onNext: { owner, status in
        owner.updateButtonState(for: status)
        owner.updateButtonIcon(for: status)
        owner.updateBubbleViewTitle(for: status)
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.missionUploadError }
      .compactMap { $0 }
      .subscribe(onNext: { error in
        WalWalToast.shared.show(type: .error, message: error.localizedDescription)
      })
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isNeedRequestPermission)
      .filter { $0 }
      .withUnretained(self)
      .flatMapLatest { owner, _ -> Observable<Void> in
        owner.permissionView = PermissionView()
        guard let permissionView = owner.permissionView else { return .empty() }
        return permissionView.showAlert()
          .flatMap {
            PermissionManager.shared.requestAllPermission()
          }
          .do(onDispose: { owner.permissionView = nil })
      }
      .subscribe { _ in
        UserDefaults.setValue(value: true, forUserDefaultKey: .checkPermission)
      }
      .disposed(by: disposeBag)
    
  }
  
  public func bindEvent() { }
}
