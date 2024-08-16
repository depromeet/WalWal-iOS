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
  targets: [
    Target(
      name: "WalWal",
      platform: .iOS,
      product: .app,
      bundleId: "olderStoneBed.io.walwal.dev", /// 우선 Develop 전용으로
      infoPlist: InfoPlist.extendingDefault(
        with:
          [
            "CFBundleIconName": "AppIcon",
            "CFBundleDevelopmentRegion": "ko_KR",
            "CFBundleShortVersionString": "0.9.0",
            "CFBundleVersion": "1",
            "UILaunchStoryboardName": "LaunchScreen",
            "ITSAppUsesNonExemptEncryption": false,
            "CFBundleURLTypes": [
              [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLName": "kakaoLogin",
                "CFBundleURLSchemes": [
                  "kakao29e3431e2dc66a607f511c0a05f0963b"
                ]
              ]
            ],
            "UIBackgroundModes": [
                "fetch",
                "remote-notification",
            ],
            "LSApplicationQueriesSchemes": [
              "kakaokompassauth"
            ]
          ]
      ),
      sources: ["Sources/**"],
      resources: [
        /// 우선 dev만 처리
        .glob(
          pattern: "Resources/**",
          excluding: ["Resources/Release/**"]
        )
      ],
      entitlements: "../WalWal.entitlements",
      dependencies: [
        .ThirdParty.KakaoSDKCommon,
        .ThirdParty.KakaoSDKAuth,
        .ThirdParty.FirebaseMessaging,
        
        .DependencyFactory.Auth.Implement,
        .DependencyFactory.Sample.Implement,
        .DependencyFactory.Splash.Implement,
        .DependencyFactory.WalWalTabBar.Implement,
        .DependencyFactory.Mission.Implement,
        .DependencyFactory.MyPage.Implement,
        .DependencyFactory.FCM.Implement,
        .DependencyFactory.Records.Implement,
        .DependencyFactory.Feed.Implement
      ],
      settings: .settings(
        base: [
          "CODE_SIGN_STYLE": "Manual",
          "DEVELOPMENT_TEAM": "6NXQDZ68FD",
          "CODE_SIGN_IDENTITY": "Apple Distribution: yongin cho (6NXQDZ68FD)"
        ]
      )
    )
  ]
)
