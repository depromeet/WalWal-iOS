//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let organizationName = "olderStoneBed.io"

let project = Project(
    name: "DesignSystem",
    organizationName: organizationName,
    settings: .settings(configurations: [
        .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
        .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
    ]),
    targets: [
        Target(
            name: "DesignSystem",
            platform: .iOS,
            product: .framework,
            bundleId: "\(organizationName).DesignSystem",
            deploymentTarget: .iOS(
                targetVersion: "15.0.0",
                devices: [.iphone]
            ),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .ThirdParty.PinLayout,
                .ThirdParty.FlexLayout,
                .ThirdParty.RxCocoa,
                .ThirdParty.RxSwift,
                .ThirdParty.RxGesture,
                .ThirdParty.Then,
                .ThirdParty.Kingfisher,
                
                .ResourceKit,
            ]),
        Target(
            name: "DesignSystemDemoApp",
            platform: .iOS,
            product: .app,
            bundleId: "\(organizationName).DesignSystemDemoApp",
            deploymentTarget: .iOS(
                targetVersion: "15.0.0",
                devices: [.iphone]
            ),
            infoPlist: InfoPlist.extendingDefault(
                with:
                    [
                        "CFBundleDevelopmentRegion": "ko_KR",
                        "CFBundleShortVersionString": "1.0",
                        "CFBundleVersion": "1",
                        "UILaunchStoryboardName": "LaunchScreen"
                    ]
            ),
            sources: ["./DemoApp/Sources/**"],
            resources: ["./DemoApp/Resources/**"],
            dependencies:
                [
                    .target(name: "DesignSystem"),
                    .ThirdParty.FlexLayout,
                    .ThirdParty.PinLayout,
                    .ThirdParty.RxCocoa,
                    .ThirdParty.RxSwift,
                    .ThirdParty.RxGesture,
                    .ThirdParty.Then,
                    .ResourceKit
                ]
        )
        
    ]
)
