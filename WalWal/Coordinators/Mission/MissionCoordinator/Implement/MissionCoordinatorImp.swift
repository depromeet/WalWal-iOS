//
//  MissionCoordinatorImp.swift
//
//  Mission
//
//  Created by 이지희
//

import UIKit
import BaseCoordinator
import MissionCoordinator
import MissionUploadCoordinator

import MissionDomain
import MissionPresenter

import MissionUploadDependencyFactory
import MissionDependencyFactory
import RecordsDependencyFactory
import ImageDependencyFactory

import RxSwift
import RxCocoa

public final class MissionCoordinatorImp: MissionCoordinator {
  
  public typealias Action = MissionCoordinatorAction
  public typealias Flow = MissionCoordinatorFlow
  
  public let disposeBag = DisposeBag()
  public let destination = PublishRelay<Flow>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public weak var parentCoordinator: (any BaseCoordinator)?
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  public var baseReactor: (any MissionReactor)?
  
  public var missionDependencyFactory: MissionDependencyFactory
  public var missionUploadDependencyFactory: MissionUploadDependencyFactory
  public var recordDependencyFactory: RecordsDependencyFactory
  public var imageDependencyFactory: ImageDependencyFactory
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    missionDependencyFactory: MissionDependencyFactory,
    missionUploadDependencyFactory: MissionUploadDependencyFactory,
    recordDependencyFactory: RecordsDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.missionDependencyFactory = missionDependencyFactory
    self.missionUploadDependencyFactory = missionUploadDependencyFactory
    self.recordDependencyFactory = recordDependencyFactory
    self.imageDependencyFactory = imageDependencyFactory
    bindChildToParentAction()
    bindState()
  }
  
  public func bindState() {
    destination
      .subscribe(with: self, onNext: { owner, flow in
        switch flow { 
        case .startMissionUpload(let recordId, let missionId):
          owner.startMissionUpload(recordId: recordId, missionId: missionId)
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, Mission이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    if let missionUploadEvent = event as? MissionUploadCoordinatorAction {
      handleMissionUploadEvent(.requireParentAction(missionUploadEvent))
    }
  }
  
  public func start() {
    /// 이런 Reactor랑 ViewController가 있다 치고~
    /// 다만, 해당 ViewController가 이 Coordinator의 Base역할을 하기 때문에, 이 ViewController에 해당하는 Reactor에 Coordinator를 주입 합니다.
    let reactor = missionDependencyFactory.injectMissionReactor(
      coordinator: self,
      todayMissionUseCase: missionDependencyFactory.injectTodayMissionUseCase(),
      checkCompletedTotalRecordsUseCase: recordDependencyFactory.injectCheckCompletedTotalRecordsUseCase(),
      checkRecordStatusUseCase: recordDependencyFactory.injectCheckRecordStatusUseCase(),
      startRecordUseCase: recordDependencyFactory.injectStartRecordUseCase()
    )
    let missionVC = missionDependencyFactory.injectMissionViewController(reactor: reactor)
    self.baseViewController = missionVC
    self.baseReactor = reactor
    self.pushViewController(viewController: missionVC, animated: false)
  }
}

// MARK: - Handle Child Actions

extension MissionCoordinatorImp {
  
    fileprivate func handleMissionUploadEvent(_ event: CoordinatorEvent<MissionUploadCoordinatorAction>) {
      switch event {
      case .finished:
        childCoordinator = nil
      case .requireParentAction(let action):
        switch action {
        case .willFetchMissionData:
          /// Mission Data를 Fetch하는 로직 reactor에 호출
          popViewController(animated: true)
          childCoordinator = nil
          baseReactor?.action.onNext(.loadInitialData)
          print("Fetch메서드 재호출")
        }
      }
    }
}

// MARK: - Create and Start(Show) with Flow(View)

extension MissionCoordinatorImp {
  
  fileprivate func startMissionUpload(recordId: Int, missionId: Int) {
    let missionUploadCoordinator = missionUploadDependencyFactory.injectMissionUploadCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      recordsDependencyFactory: recordDependencyFactory,
      imageDependencyFactory: imageDependencyFactory,
      recordId: recordId,
      missionId: missionId
    )
    self.childCoordinator = missionUploadCoordinator
    missionUploadCoordinator.start()
  }
  
  //  /// 새로운 Coordinator를 통해서 새로운 Flow를 생성하기 때문에, start를 prefix로 사용합니다.
  //  fileprivate func start__() {
  //    let __Coordinator = dependencyFactory.make__Coordinator(
  //      navigationController: navigationController,
  //      parentCoordinator: self
  //    )
  //    childCoordinator = __Coordinator
  //    __Coordinator.start()
  //  }
  //
  //  /// 단순히, VC를 보여주는 로직이기 때문에, show를 prefix로 사용합니다.
  //  fileprivate func show__() {
  //    let reactor = dependencyFactory.make__Reactor(coordinator: self)
  //    let __VC = dependencyFactory.make__ViewController(reactor: reactor)
  //    self.pushViewController(viewController: __VC, animated: false)
  //  }
}



// MARK: - Mission(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension MissionCoordinatorImp {
  public func startMyPage() {
    requireParentAction(.startMyPage)
  }
}
