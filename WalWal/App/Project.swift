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
            bundleId: "olderStoneBed.io.walwal",
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
            dependencies: [
              .ThirdParty.Alamofire,
              .ThirdParty.RxSwift,
              .ThirdParty.RxRelay,
              .ThirdParty.RxCocoa,
              .ThirdParty.RxGesture,
              .ThirdParty.Kingfisher,
              .ThirdParty.FlexLayout,
              .ThirdParty.PinLayout,
              .ThirdParty.Then,
              
              .ResourceKit,
              .DesignSystem
            ]
        )
    ]
)
