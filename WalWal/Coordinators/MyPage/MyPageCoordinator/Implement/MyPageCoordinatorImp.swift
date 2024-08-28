//
//  MyPageCoordinatorImp.swift
//
//  MyPage
//
//  Created by 조용인
//

import UIKit
import DesignSystem
import MyPageDependencyFactory
import FCMDependencyFactory
import AuthDependencyFactory
import MembersDependencyFactory
import FeedDependencyFactory
import ImageDependencyFactory
import SafariServices

import BaseCoordinator
import MyPageCoordinator

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
  
  private let myPageDependencyFactory: MyPageDependencyFactory
  private let fcmDependencyFactory: FCMDependencyFactory
  private let authDependencyFactory: AuthDependencyFactory
  private let membersDependencyFactory: MembersDependencyFactory
  private let feedDependencyFactory: FeedDependencyFactory
  private let imageDependencyFactory: ImageDependencyFactory
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    myPageDependencyFactory: MyPageDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory,
    FeedDependencyFactory: FeedDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.myPageDependencyFactory = myPageDependencyFactory
    self.fcmDependencyFactory = fcmDependencyFactory
    self.authDependencyFactory = authDependencyFactory
    self.membersDependencyFactory = membersDependencyFactory
    self.feedDependencyFactory = FeedDependencyFactory
    self.imageDependencyFactory = imageDependencyFactory
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
        }
      })
      .disposed(by: disposeBag)
  }
  
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    /// if let __Event = event as? CoordinatorEvent<__CoordinatorAction> {
    ///   handle__Event(__Event)
    /// } else if let __Event = event as? CoordinatorEvent<__CoordinatorAction> {
    ///   handle__Event(__Event)
    /// }
  }
  
  public func start() {
    let fetchWalWalCalendarModelsUseCase = myPageDependencyFactory.injectFetchWalWalCalendarModelsUseCase()
    let fetchMemberInfoUseCase = membersDependencyFactory.injectFetchMemberInfoUseCase()
    let fetchUserFeedUseCase = feedDependencyFactory.injectFetchFeedUseCase()
    let reactor = myPageDependencyFactory.injectMyPageReactor(
      coordinator: self,
      fetchWalWalCalendarModelsUseCase: fetchWalWalCalendarModelsUseCase,
      fetchMemberInfoUseCase: fetchMemberInfoUseCase
    )
    let myPageVC = myPageDependencyFactory.injectMyPageViewController(reactor: reactor)
    self.baseViewController = myPageVC
    self.pushViewController(viewController: myPageVC, animated: false)
  }
}

// MARK: - Handle Child Actions

extension MyPageCoordinatorImp {
  
  /// fileprivate func handle__Event(_ event: CoordinatorEvent<__CoordinatorAction>) {
  ///   switch event {
  ///   case .finished:
  ///     childCoordinator = nil
  ///   case .requireParentAction(let action):
  ///     switch action { }
  ///   }
  /// }
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
    let reactor = myPageDependencyFactory.injectRecordDetailReactor(
      coordinator: self,
      fetchUserFeedUseCase: fetchUserFeedUseCase)
    let recordDetailVC = myPageDependencyFactory.injectRecordDetailViewController(
      reactor: reactor,
      memberId: memberId,
      memberNickname: nickname,
      recordId: recordId
    )
    guard let tabBarViewController = navigationController.tabBarController as? WalWalTabBarViewController else {
      return
    }
    tabBarViewController.hideCustomTabBar()
    self.pushViewController(viewController: recordDetailVC, animated: true)
  }
  
  /// 프로필 설정뷰
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
    let ProfileEditVC = myPageDependencyFactory.injectProfileEditViewController(
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
    self.pushViewController(viewController: ProfileEditVC, animated: false)
  }
}



// MARK: - MyPage(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension MyPageCoordinatorImp {
  public func startAuth() {
    requireParentAction(.startAuth)
  }
}
