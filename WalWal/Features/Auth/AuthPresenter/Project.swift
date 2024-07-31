//
//  AuthPresenterProject.swift
//
//  Auth
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "AuthPresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
    
    .Feature.Auth.Domain.Interface
  ],
  implementDependencies: [
    .ThirdParty.KakaoSDKAuth,
    .ThirdParty.KakaoSDKUser,
    
    .DependencyFactory.Auth.Interface,
    .DesignSystem,
    .Utility,
    .LocalStorage
  ],
  demoAppDependencies: [
    .DependencyFactory.Auth.Implement
  ],
  infoPlist: .extendingDefault(
    with:
      [
        "CFBundleDevelopmentRegion": "ko_KR",
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1.0.0",
        "UILaunchStoryboardName": "LaunchScreen",
        "NSAppTransportSecurity" : [
          "NSAllowsArbitraryLoads": true
        ],
        "NSCameraUsageDescription": "미션 인증 사진 촬영을 위해 카메라 권한이 필요합니다.",
        "NSPhotoLibraryUsageDescription": "프로필 이미지를 선택하기 위해 앨범 접근 권한이 필요합니다."
      ]
  )
)
