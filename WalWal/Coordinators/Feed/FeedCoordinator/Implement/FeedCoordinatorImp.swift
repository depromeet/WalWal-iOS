//
//  FeedCoordinatorImp.swift
//
//  Feed
//
//  Created by 이지희
//

import UIKit
import DesignSystem

import FeedPresenter

import FeedDependencyFactory
import RecordsDependencyFactory
import FCMDependencyFactory
import CommentDependencyFactory

import BaseCoordinator
import FeedCoordinator
import CommentCoordinator

import RxSwift
import RxCocoa

public final class FeedCoordinatorImp: FeedCoordinator {
  
  public typealias Action = FeedCoordinatorAction
  public typealias Flow = FeedCoordinatorFlow
  
  public let disposeBag = DisposeBag()
  public let destination = PublishRelay<Flow>()
  public let doubleTapRelay = PublishRelay<Int>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public weak var parentCoordinator: (any BaseCoordinator)?
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  /// 바텀시트 내부에서 네비게이션을 사용하기 위한 프로퍼티
  private var bottomSheetNavigaionController: UINavigationController?
  /// 댓글 dimiss 시 Reactor에 동작 요청을 위한 BaseReactor
  public var baseReactor: (any FeedReactor)?
  
  public var feedDependencyFactory: FeedDependencyFactory
  public var recordsDependencyFactory: RecordsDependencyFactory
  public var commentDependencyFactory: CommentDependencyFactory
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    feedDependencyFactory: FeedDependencyFactory,
    recordsDependencyFactory: RecordsDependencyFactory,
    commentDependencyFactory: CommentDependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.feedDependencyFactory = feedDependencyFactory
    self.recordsDependencyFactory = recordsDependencyFactory
    self.commentDependencyFactory = commentDependencyFactory
    bindChildToParentAction()
    bindState()
  }
  
  public func bindState() {
    destination
      .subscribe(with: self, onNext: { owner, flow in
        switch flow {
        case let .showFeedMenu(recordId):
          self.showFeedMenu(recordId: recordId)
        case let .showReportView(recordId):
          self.showReportType(recordId: recordId)
        case let .showReportDetailView(recordId, reportType):
          self.showReportDetail(recordId: recordId, reportType: reportType)
        case let .showCommentView(recordId, writerNickname, commentId):
          self.showComment(
            recordId: recordId,
            writerNickname: writerNickname,
            commentId: commentId
          )
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, Feed이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    if let commentEvent = event as? CommentCoordinatorAction {
      handleCommentEvent(.requireParentAction(commentEvent))
    }
  }
  
  public func start() {
    let fetchFeedUseCase = feedDependencyFactory.injectFetchFeedUseCase()
    let updateBoostCountUseCase =  recordsDependencyFactory.injectUpdateRecordUseCase()
    let removeGlobalRecordIdUseCase = feedDependencyFactory.injectRemoveGlobalRecordIdUseCase()
    let fetchSingleFeedUseCase = feedDependencyFactory.injectFetchSingleFeedUseCase()
    
    let reactor = feedDependencyFactory.injectFeedReactor(
      coordinator: self,
      fetchFeedUseCase: fetchFeedUseCase,
      updateBoostCountUseCase: updateBoostCountUseCase,
      removeGlobalRecordIdUseCase: removeGlobalRecordIdUseCase,
      fetchSingleFeedUseCase: fetchSingleFeedUseCase
    )
    
    let feedVC = feedDependencyFactory.injectFeedViewController(reactor: reactor)
    self.baseViewController = feedVC
    self.baseReactor = reactor
    
    doubleTapRelay
      .subscribe(with: self, onNext: { owner, index in
        reactor.action.onNext(.doubleTap(index))
      })
      .disposed(by: disposeBag)
    
    self.pushViewController(viewController: feedVC, animated: false)
    
  }
}

// MARK: - Handle Child Actions

extension FeedCoordinatorImp {
  
  fileprivate func handleCommentEvent(_ event: CoordinatorEvent<CommentCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case .requireParentAction(let action):
      switch action {
      case .dismissComment(let recordId, let commentCount):
        self.childCoordinator = nil
        self.baseReactor?.action.onNext(.refreshFeedData(recordId, commentCount))
      }
    }
  }
}

// MARK: - Create and Start(Show) with Flow(View)

extension FeedCoordinatorImp {
  
  private func showFeedMenu(recordId: Int) {
    let reactor = feedDependencyFactory.injectFeedMenuReactor(
      coordinator: self,
      recordId: recordId
    )
    let vc = feedDependencyFactory.injectFeedMenuViewController(reactor: reactor)
    self.presentViewController(viewController: vc, style: .overFullScreen, animated: false)
  }
  
  private func showReportType(recordId: Int) {
    let reactor = feedDependencyFactory.injectReportTypeReactor(
      coordinator: self,
      recordId: recordId
    )
    let vc = feedDependencyFactory.injectReportTypeViewController(
      reactor: reactor
    )
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationController?.setNavigationBarHidden(true, animated: false)
    self.bottomSheetNavigaionController = nav
    self.presentViewController(
      viewController: nav,
      style: .overFullScreen,
      animated: false
    )
  }
  
  private func showReportDetail(recordId: Int, reportType: String) {
    let reportUseCase = feedDependencyFactory.injectReportUseCase()
    let reactor = feedDependencyFactory.injectReportDetailReactor(
      coordinator: self,
      reportUseCase: reportUseCase,
      recordId: recordId,
      reportType: reportType
    )
    let vc = feedDependencyFactory.injectReportDetailViewController(reactor: reactor)
    bottomSheetNavigaionController?.setNavigationBarHidden(true, animated: false)
    bottomSheetNavigaionController?.pushViewController(vc, animated: false)
  }
  
  public func showComment(recordId: Int, writerNickname: String, commentId: Int?) {
    print("feedCoord ", commentId)
    let coordinator = commentDependencyFactory.injectCommentCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      recordId: recordId,
      writerNickname: writerNickname,
      commentId: commentId
    )
    childCoordinator = coordinator
    coordinator.start()
    
  }
}



// MARK: - Feed(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension FeedCoordinatorImp {
  public func startProfile(memberId: Int, nickName: String) {
    requireParentAction(.startProfile(memberId: memberId, nickName: nickName))
  }
  
  public func doubleTap(index: Int) {
    doubleTapRelay.accept(index)
  }
  
  public func startReport(recordId: Int) {
    self.dismissViewController(animated: false, completion: nil)
    showReportType(recordId: recordId)
  }
  
  public func popReportDetail() {
    bottomSheetNavigaionController?.popViewController(animated: false)
  }
  
}
