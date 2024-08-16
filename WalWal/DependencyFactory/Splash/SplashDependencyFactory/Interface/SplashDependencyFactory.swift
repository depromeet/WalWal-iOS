//
//  SplashDependencyFactoryInterface.swift
//
//  Splash
//
//  Created by 조용인
//

import UIKit

import AuthDependencyFactory
import WalWalTabBarDependencyFactory
import MissionDependencyFactory
import MyPageDependencyFactory
import FCMDependencyFactory
import OnboardingDependencyFactory
import FeedDependencyFactory

import AppCoordinator
import SplashDomain
import SplashPresenter

public protocol SplashDependencyFactory {
  func makeAppCoordinator(
    navigationController: UINavigationController,
    authDependencyFactory: AuthDependencyFactory,
    walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory,
    missionDependencyFactory: MissionDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    onboardingDependencyFactory: OnboardingDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory
  ) -> any AppCoordinator
  func makeCheckTokenUseCase() -> CheckTokenUsecase
  func makeSplashReactor<T: AppCoordinator>(coordinator: T) -> any SplashReactor
  func makeSplashViewController<T: SplashReactor>(reactor: T) -> any SplashViewController
}
