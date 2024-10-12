//
//  MyPageCoordinatorImp.swift
//
//  MyPage
//
//  Created by 조용인
//

import UIKit
import DesignSystem

import MyPagePresenter

import MyPageDependencyFactory
import FCMDependencyFactory
import AuthDependencyFactory
import MembersDependencyFactory
import FeedDependencyFactory
import ImageDependencyFactory
import RecordsDependencyFactory
import CommentDependencyFactory
import SafariServices

import BaseCoordinator
import MyPageCoordinator
import CommentCoordinator

import DesignSystem

import RxSwift
import RxCocoa

public final class MyPageCoordinatorImp: MyPageCoordinator {
  
  public typealias Action = MyPageCoordinatorAction
  public typealias Flow = MyPageCoordinatorFlow
  
  public let disposeBag = DisposeBag()
  public let destination = PublishRelay<Flow>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public weak var parentCoordinator: (any BaseCoordinator)?
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  public var baseReactor: (any RecordDetailReactor)?
  
  private let myPageDependencyFactory: MyPageDependencyFactory
  private let fcmDependencyFactory: FCMDependencyFactory
  private let authDependencyFactory: AuthDependencyFactory
  private let membersDependencyFactory: MembersDependencyFactory
  private let feedDependencyFactory: FeedDependencyFactory
  private let imageDependencyFactory: ImageDependencyFactory
  private let recordsDependencyFactory: RecordsDependencyFactory
  private let commentDependencyFactory: CommentDependencyFactory
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    myPageDependencyFactory: MyPageDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory,
    FeedDependencyFactory: FeedDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory,
    recordsDependencyFactory: RecordsDependencyFactory,
    commentDependencyFactory: CommentDependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.myPageDependencyFactory = myPageDependencyFactory
    self.fcmDependencyFactory = fcmDependencyFactory
    self.authDependencyFactory = authDependencyFactory
    self.membersDependencyFactory = membersDependencyFactory
    self.feedDependencyFactory = FeedDependencyFactory
    self.imageDependencyFactory = imageDependencyFactory
    self.recordsDependencyFactory = recordsDependencyFactory
    self.commentDependencyFactory = commentDependencyFactory
    bindChildToParentAction()
    bindState()
  }
  
  public func bindState() {
    destination
      .subscribe(with: self, onNext: { owner, flow in
        switch flow {
        case let .showRecordDetail(nickname, memberId, recordId):
          owner.showRecordDetailVC(
            nickname: nickname,
            memberId: memberId,
            recordId: recordId
          )
        case let .showProfileEdit(nickname, defaultProfile, selectImage, raisePet):
          owner.showProfileEditVC(
            nickname: nickname,
            defaultProfile: defaultProfile,
            selectImage: selectImage,
            raisePet: raisePet
          )
        case .showProfileSetting:
          owner.showProfileSettingVC()
        case .showPrivacyInfoPage:
          owner.showPrivacyPageVC()
        case .showServiceInfoPage:
          owner.showServicePageVC()
        case let .showCommentView(recordId, writerNickname):
          owner.showComment(recordId: recordId, writerNickname: writerNickname)
        }
      })
      .disposed(by: disposeBag)
  }
  
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    if let commentEvent = event as? CommentCoordinatorAction {
    ///   handle__Event(__Event)
      handleCommentEvent(.requireParentAction(commentEvent))
    }
  }
  
  public func start() {
    let fetchWalWalCalendarModelsUseCase = myPageDependencyFactory.injectFetchWalWalCalendarModelsUseCase()
    let fetchMemberInfoUseCase = membersDependencyFactory.injectFetchMemberInfoUseCase()
    let memberProfileInfoUseCase = membersDependencyFactory.injectMemberInfoUseCase()
    let checkCompletedTotalRecordsUseCase = recordsDependencyFactory.injectCheckCompletedTotalRecordsUseCase()
    let checkCalendarRecordsUseCase = recordsDependencyFactory.injectCheckCalendarRecordsUseCase()
  
    let reactor = myPageDependencyFactory.injectMyPageReactor (
      coordinator: self,
      fetchWalWalCalendarModelsUseCase: fetchWalWalCalendarModelsUseCase,
      fetchMemberInfoUseCase: fetchMemberInfoUseCase,
      checkCompletedTotalRecordsUseCase: checkCompletedTotalRecordsUseCase,
      checkCalendarRecordsUseCase: checkCalendarRecordsUseCase,
      memberProfileInfoUseCase: memberProfileInfoUseCase,
      memberId: nil,
      isFeedProfile: false
    )
    let myPageVC = myPageDependencyFactory.injectMyPageViewController(
      reactor: reactor,
      memberId: nil,
      nickName: nil,
      isOther: false
    )
    self.baseViewController = myPageVC
    self.pushViewController(viewController: myPageVC, animated: false)
  }
  
  public func startProfile(
    memberId: Int,
    nickName: String
  ) {
    let fetchWalWalCalendarModelsUseCase = myPageDependencyFactory.injectFetchWalWalCalendarModelsUseCase()
    let fetchMemberInfoUseCase = membersDependencyFactory.injectFetchMemberInfoUseCase()
    let checkCompletedTotalRecordsUseCase = recordsDependencyFactory.injectCheckCompletedTotalRecordsUseCase()
    let checkCalendarRecordsUseCase = recordsDependencyFactory.injectCheckCalendarRecordsUseCase()
    let memberProfileInfoUseCase = membersDependencyFactory.injectMemberInfoUseCase()
    let reactor = myPageDependencyFactory.injectMyPageReactor(
      coordinator: self,
      fetchWalWalCalendarModelsUseCase: fetchWalWalCalendarModelsUseCase,
      fetchMemberInfoUseCase: fetchMemberInfoUseCase,
      checkCompletedTotalRecordsUseCase: checkCompletedTotalRecordsUseCase,
      checkCalendarRecordsUseCase: checkCalendarRecordsUseCase,
      memberProfileInfoUseCase: memberProfileInfoUseCase,
      memberId: memberId,
      isFeedProfile: true
    )
    let profileVC = myPageDependencyFactory.injectMyPageViewController(
      reactor: reactor,
      memberId: memberId,
      nickName: nickName,
      isOther: true
    )
    self.baseViewController = profileVC
    self.pushViewController(viewController: profileVC, animated: true)
  }
}

// MARK: - Handle Child Actions

extension MyPageCoordinatorImp {
  
  fileprivate func handleCommentEvent(_ event: CoordinatorEvent<CommentCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case .requireParentAction(let action):
      switch action {
      case .dismissComment(let recordId):
        self.childCoordinator = nil
        self.baseReactor?.action.onNext(.refreshFeedData(recordId: recordId))
      }
    }
  }
  
}

// MARK: - Create and Start(Show) with Flow(View)

extension MyPageCoordinatorImp {
  
  /// 개인정보 처리 방침 페이지
  private func showPrivacyPageVC() {
    let reactor = myPageDependencyFactory.injectTermsReactor(coordinator: self)
    let privacyPage = myPageDependencyFactory.injectTermsViewController(
      reactor: reactor,
      type: .privacy
    )
    self.presentViewController(viewController: privacyPage, style: .fullScreen)
  }
  
  /// 서비스 이용 약관 페이지
  private func showServicePageVC() {
    let reactor = myPageDependencyFactory.injectTermsReactor(coordinator: self)
    let servicePage = myPageDependencyFactory.injectTermsViewController(
      reactor: reactor,
      type: .service
    )
    self.presentViewController(viewController: servicePage, style: .fullScreen)
  }
  
  /// 기록 상세뷰
  fileprivate func showRecordDetailVC(
    nickname: String,
    memberId: Int,
    recordId: Int
  ) {
    let fetchUserFeedUseCase = feedDependencyFactory.injectFetchUserFeedUseCase()
    let fetchSingleFeedUseCase = feedDependencyFactory.injectFetchSingleFeedUseCase()
    let reactor = myPageDependencyFactory.injectRecordDetailReactor(
      coordinator: self,
      fetchUserFeedUseCase: fetchUserFeedUseCase,
      fetchSingleFeedUseCase: fetchSingleFeedUseCase,
      memberId: memberId
    )
    let recordDetailVC = myPageDependencyFactory.injectRecordDetailViewController(
      reactor: reactor,
      memberId: memberId,
      memberNickname: nickname,
      recordId: recordId
    )
    
    self.baseReactor = reactor
    
    if let tabBarViewController = navigationController.tabBarController as? WalWalTabBarViewController {
      tabBarViewController.hideCustomTabBar()
    }
    self.pushViewController(viewController: recordDetailVC, animated: true)
  }
  
  /// 설정뷰
  fileprivate func showProfileSettingVC() {
    
    let reactor = myPageDependencyFactory.injectProfileSettingReactor(
      coordinator: self,
      tokenDeleteUseCase: authDependencyFactory.injectTokenDeleteUseCase(),
      fcmDeleteUseCase: fcmDependencyFactory.injectFCMDeleteUseCase(),
      withdrawUseCase: authDependencyFactory.injectWithdrawUseCase(),
      kakaoLogoutUseCase: authDependencyFactory.injectKakaoLogoutUseCase(),
      kakaoUnlinkUseCase: authDependencyFactory.injectKakaoUnlinkUseCase()
    )

    let profileSettingVC = myPageDependencyFactory.injectProfileSettingViewController(reactor: reactor)
    guard let tabBarViewController = navigationController.tabBarController as? WalWalTabBarViewController else {
      return
    }
    tabBarViewController.hideCustomTabBar()
    self.pushViewController(viewController: profileSettingVC, animated: true)
  }
  
  /// 프로필 변경뷰
  fileprivate func showProfileEditVC(
    nickname: String,
    defaultProfile: String?,
    selectImage: UIImage?,
    raisePet: String
  ) {
    let editProfileUseCase = membersDependencyFactory.injectEditProfileUseCase()
    let checkNicknameUseCase = membersDependencyFactory.injectCheckNicknameUseCase()
    let fetchMemberInfoUseCase = membersDependencyFactory.injectFetchMemberInfoUseCase()
    let uploadMemberInfoUseCase = imageDependencyFactory.injectUploadMemberUseCase()
    let memberInfoUseCase = membersDependencyFactory.injectMemberInfoUseCase()
    let reactor = myPageDependencyFactory.injectProfileEditReactor(
      coordinator: self,
      editProfileUseCase: editProfileUseCase,
      checkNicknameUseCase: checkNicknameUseCase,
      fetchMemberInfoUseCase: fetchMemberInfoUseCase,
      uploadMemberUseCase: uploadMemberInfoUseCase,
      memberInfoUseCase: memberInfoUseCase
    )
    let profileEditVC = myPageDependencyFactory.injectProfileEditViewController(
      reactor: reactor,
      nickname: nickname,
      defaultProfile: defaultProfile,
      selectImage: selectImage,
      raisePet: raisePet
    )
    guard let tabBarViewController = navigationController.tabBarController as? WalWalTabBarViewController else {
      return
    }
    
    tabBarViewController.hideCustomTabBar()
    self.presentViewController(viewController: profileEditVC, style: .fullScreen)
  }
  
  public func showComment(recordId: Int, writerNickname: String) {
    let coordinator = commentDependencyFactory.injectCommentCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      recordId: recordId,
      writerNickname: writerNickname
    )
    childCoordinator = coordinator
    coordinator.start()
  }
}



// MARK: - MyPage(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension MyPageCoordinatorImp {
  public func startAuth() {
    requireParentAction(.startAuth)
  }
}
