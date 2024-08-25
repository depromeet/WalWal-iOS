//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project(
  name: "WalWal",
  packages: [
    .remote(url: "https://github.com/firebase/firebase-ios-sdk.git",
            requirement: .upToNextMajor(from: "10.25.0"))
  ],
  settings: .settings(
    configurations: [
      .debug(name: .debug),
      .release(name: .release)
    ]
  ),
  targets: [
    .makeApp(
      name: "DEV-WalWalApp",
      platform: .iOS,
      bundleId: "olderStoneBed.io.walwal.dev",
      iOSTargetVersion: "16.0.0",
      infoPlistPath: "App/WalWal-Info.plist",
      removeResource: "Release",
      entitlements: "App/Resources/Dev/WalWal-Dev.entitlements",
      dependencies: [
        .ThirdParty.KakaoSDKCommon,
        .ThirdParty.FirebaseMessaging,
        
          .DependencyFactory.Auth.Implement,
        .DependencyFactory.Splash.Implement,
        .DependencyFactory.WalWalTabBar.Implement,
        .DependencyFactory.Mission.Implement,
        .DependencyFactory.MissionUpload.Implement,
        .DependencyFactory.MyPage.Implement,
        .DependencyFactory.FCM.Implement,
        .DependencyFactory.Image.Implement,
        .DependencyFactory.Onboarding.Implement,
        .DependencyFactory.Records.Implement,
        .DependencyFactory.Feed.Implement,
        .DependencyFactory.Members.Implement
      ],
      settings: .settings(
        configurations: [
          .debug(name: .debug, xcconfig: "../Config/Debug.xcconfig")
        ]
      )
    ),
    .makeApp(
      name: "PROD-WalWalApp",
      platform: .iOS,
      bundleId: "olderStoneBed.io.walwal",
      iOSTargetVersion: "16.0.0",
      infoPlistPath: "App/WalWal-Info.plist",
      removeResource: "Dev",
      entitlements: "App/Resources/Release/WalWal-Release.entitlements",
      dependencies: [
        .ThirdParty.KakaoSDKCommon,
        .ThirdParty.FirebaseMessaging,
        
          .DependencyFactory.Auth.Implement,
        .DependencyFactory.Splash.Implement,
        .DependencyFactory.WalWalTabBar.Implement,
        .DependencyFactory.Mission.Implement,
        .DependencyFactory.MissionUpload.Implement,
        .DependencyFactory.MyPage.Implement,
        .DependencyFactory.FCM.Implement,
        .DependencyFactory.Image.Implement,
        .DependencyFactory.Onboarding.Implement,
        .DependencyFactory.Records.Implement,
        .DependencyFactory.Feed.Implement,
        .DependencyFactory.Members.Implement
      ],
      settings: .settings(
        configurations: [
          .release(name: .release, xcconfig: "../Config/Release.xcconfig")
        ]
      )
    )
  ]
)
