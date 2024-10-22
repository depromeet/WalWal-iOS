//
//  CommentCoordinatorImp.swift
//
//  Comment
//
//  Created by 이지희
//

import UIKit
import CommentDependencyFactory
import BaseCoordinator
import CommentCoordinator

import RxSwift
import RxCocoa

public final class CommentCoordinatorImp: CommentCoordinator {
  
  public typealias Action = CommentCoordinatorAction
  public typealias Flow = CommentCoordinatorFlow
  
  public let disposeBag = DisposeBag()
  public let destination = PublishRelay<Flow>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public weak var parentCoordinator: (any BaseCoordinator)?
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  
  public var commentDependencyFactory: CommentDependencyFactory
  
  private let recordId: Int
  private var writerNickname: String
  private var focusCommentId: Int?
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    commentDependencyFactory: CommentDependencyFactory,
    recordId: Int,
    writerNickname: String,
    commentId: Int?
  ) {
    self.recordId = recordId
    self.writerNickname = writerNickname
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.commentDependencyFactory = commentDependencyFactory
    self.focusCommentId = commentId
    bindChildToParentAction()
    bindState()
  }
  
  public func bindState() {
    destination
      .subscribe(with: self, onNext: { owner, flow in
        switch flow { }
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, Comment이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
//    if let __Event = event as? CoordinatorEvent<__CoordinatorAction> {
//      handle__Event(__Event)
//    } else if let __Event = event as? CoordinatorEvent<__CoordinatorAction> {
//      handle__Event(__Event)
//    }
  }
  
  public func start() {
    let getCommentsUsecase = commentDependencyFactory.injectGetCommentsUseCase()
    let postCommentUsecase = commentDependencyFactory.injectPostCommentUsecase()
    let flattenCommentUsecase = commentDependencyFactory.injectFlattenCommentsUsecase()
    
    let reactor = commentDependencyFactory.injectCommentReactor(
      coordinator: self,
      getCommentsUsecase: getCommentsUsecase,
      postCommentUsecase: postCommentUsecase,
      flattenCommentUsecase: flattenCommentUsecase,
      recordId: recordId,
      writerNickname: writerNickname,
      focusCommentId: focusCommentId
    )
    let commentVC = commentDependencyFactory.injectCommentViewController(reactor: reactor)
    self.baseViewController = commentVC
    self.presentViewController(viewController: commentVC, style: .overFullScreen, animated: false)
  }
}

// MARK: - Handle Child Actions

extension CommentCoordinatorImp {

}

// MARK: - Create and Start(Show) with Flow(View)

extension CommentCoordinatorImp {

}



// MARK: - Comment(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension CommentCoordinatorImp {
  public func reloadFeedAt(_ recordId: Int) {
    print("피드 업데이트, 부모 이밴트 요청")
    self.dismissViewController { [weak self] in
      self?.requireFromChild.onNext(.requireParentAction(.dismissComment(recordId)))
    }
  }
  
  public func moveToWriterPage(_ writerId: Int, _ nickname: String) {
    print("작성자 페이지로 이동, 부모 이밴트 요청")
    self.dismissViewController { [weak self] in
      self?.requireFromChild.onNext(.requireParentAction(.moveToWriterPage(writerId, nickname)))
    }
  }
}
