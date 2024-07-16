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
            "UILaunchStoryboardName": "LaunchScreen"
          ]
      ),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      entitlements: "../WalWal.entitlements",
      dependencies: [
        .ThirdParty.RxAlamofire,
        .ThirdParty.RxSwift,
        .ThirdParty.RxRelay,
        .ThirdParty.RxCocoa,
        .ThirdParty.RxGesture,
        .ThirdParty.Kingfisher,
        .ThirdParty.FlexLayout,
        .ThirdParty.PinLayout,
        .ThirdParty.Then,
        
        .ResourceKit,
        .DesignSystem,
        .Utility,
        .WalWalNetwork.Interface,
        .WalWalNetwork.Implement,
        .DependencyFactory.Interface,
        .DependencyFactory.Implement
      ]
    )
  ]
)
