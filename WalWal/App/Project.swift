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
  targets: [
    Target(
      name: "WalWal",
      platform: .iOS,
      product: .app,
      bundleId: "olderStoneBed.io.walwal.dev", /// 우선 Develop 전용으로
      infoPlist: InfoPlist.extendingDefault(
        with:
          [
            "CFBundleDevelopmentRegion": "ko_KR",
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UILaunchStoryboardName": "LaunchScreen",
            "CFBundleURLTypes": [
              [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLName": "kakaoLogin",
                "CFBundleURLSchemes": [
                  "kakao29e3431e2dc66a607f511c0a05f0963b"
                ]
              ]
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
        .DependencyFactory.MyPage.Implement
      ]
    )
  ]
)
