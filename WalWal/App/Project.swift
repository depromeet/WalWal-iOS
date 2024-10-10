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
      script: [
        .pre(script: """
              # 실제 경로 확인
              echo "SRCROOT: ${SRCROOT}"
              GOOGLE_SERVICE_INFO_PATH="${SRCROOT}/Resources/Dev/GoogleService-Info.plist"
              echo "GoogleService-Info.plist path: $GOOGLE_SERVICE_INFO_PATH"
              
              DEST_DIR="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app"
              
              if [ ! -f "$GOOGLE_SERVICE_INFO_PATH" ]; then
                echo "Error: GoogleService-Info.plist for Dev does not exist at $GOOGLE_SERVICE_INFO_PATH"
                exit 1
              fi
              
              mkdir -p "$DEST_DIR"
              cp "$GOOGLE_SERVICE_INFO_PATH" "$DEST_DIR/GoogleService-Info.plist"
              echo "Successfully copied Dev GoogleService-Info.plist to $DEST_DIR"
              """, name: "Copy Firebase Config for Dev", basedOnDependencyAnalysis: false)
      ],
      dependencies: [
        .ThirdParty.KakaoSDKCommon,
        .ThirdParty.FirebaseMessaging,
        .ThirdParty.FirebaseCrashlytics,
        
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
        .DependencyFactory.Comment.Implement,
        .DependencyFactory.Members.Implement
      ],
      settings: .settings(
        configurations: [
          .debug(name: .debug, xcconfig: "../Config/Debug.xcconfig")
        ]
      )
    ),
    .makeApp(
      name: "WalWal",
      platform: .iOS,
      bundleId: "olderStoneBed.io.walwal",
      iOSTargetVersion: "16.0.0",
      infoPlistPath: "App/WalWal-Info.plist",
      removeResource: "Dev",
      entitlements: "App/Resources/Release/WalWal-Release.entitlements",
      script: [
        .pre(script: """
              # GoogleService-Info.plist 복사
              GOOGLE_SERVICE_INFO_PATH="${SRCROOT}/Resources/Release/GoogleService-Info.plist"
              DEST_DIR="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app"
              
              if [ ! -f "$GOOGLE_SERVICE_INFO_PATH" ]; then
                echo "Error: GoogleService-Info.plist for Release does not exist."
                exit 1
              fi
              
              mkdir -p "$DEST_DIR"
              cp "$GOOGLE_SERVICE_INFO_PATH" "$DEST_DIR/GoogleService-Info.plist"
              echo "Successfully copied Release GoogleService-Info.plist to $DEST_DIR"
              """, name: "Copy Firebase Config for Release", basedOnDependencyAnalysis: false)
      ],
      dependencies: [
        .ThirdParty.KakaoSDKCommon,
        .ThirdParty.FirebaseMessaging,
        .ThirdParty.FirebaseCrashlytics,
        
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
        .DependencyFactory.Comment.Implement,
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
