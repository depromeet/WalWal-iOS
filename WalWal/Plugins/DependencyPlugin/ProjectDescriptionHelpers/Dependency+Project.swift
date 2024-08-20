//
//  Dependency+Project.swift
//  MyPlugin
//
//  Created by 조용인 on 6/22/24.
//

import Foundation
import ProjectDescription

//MARK: - Target Dependency관련 확장 (Target별 상세 Dependency)

/// Feature의 폴더 구분을 위한 Layer 케이스
enum Layer: String {
  case domain = "Domain"
  case data = "Data"
  case presenter = "Presenter"
}

enum DependencyFactoryStr: String {
  case splash = "Splash"
  case auth = "Auth"
  case onboarding = "Onboarding"
  case walwalTabBar = "WalWalTabBar"
  case mission = "Mission"
  case myPage = "MyPage"
  case feed = "Feed"
  case fcm = "FCM"
  case records = "Records"
  case image = "Image"
  case missionUpload = "MissionUpload"
  case members = "Members"
}

enum CoordinatorStr: String {
  case base = "Base"
  case app = "App"
  case walwalTabBar = "WalWalTabBar"
  case auth = "Auth"
  case onboarding = "Onboarding"
  case mission = "Mission"
  case feed = "Feed"
  case myPage = "MyPage"
  case missionUpload = "MissionUpload"
}

enum FeatureStr: String {
  case splash = "Splash"
  case auth = "Auth"
  case onboarding = "Onboarding"
  case mission = "Mission"
  case myPage = "MyPage"
  case fcm = "FCM"
  case records = "Records"
  case image = "Image"
  case feed = "Feed"
  case missionUpload = "MissionUpload"
  case members = "Members"
}

protocol WalWalDependency {
  static func project(name: FeatureStr, layer: Layer, isInterface: Bool) -> TargetDependency
  static func project(name: CoordinatorStr, isInterface: Bool) -> TargetDependency
  static func project(dependencyName: DependencyFactoryStr, isInterface: Bool) -> TargetDependency
}

extension WalWalDependency {
  
  static func project(name: FeatureStr, layer: Layer, isInterface: Bool) -> TargetDependency {
    let name = name.rawValue
    let layer = layer.rawValue
    let postfix: String = isInterface ? "" : "Imp"
    let folderFullName = "\(name)\(layer)\(postfix)"
    return .project(target: folderFullName,
                    path: .relativeToRoot("Features/\(name)/\(name)\(layer)"))
  }
  
  static func project(name: CoordinatorStr, isInterface: Bool) -> TargetDependency {
    let name = name.rawValue
    let layer = "Coordinator"
    let postfix: String = isInterface ? "" : "Imp"
    let folderFullName = "\(name)\(layer)\(postfix)"
    return .project(target: folderFullName,
                    path: .relativeToRoot("Coordinators/\(name)/\(name)\(layer)"))
  }
  
  static func project(dependencyName: DependencyFactoryStr, isInterface: Bool) -> TargetDependency {
    let name = dependencyName.rawValue
    let layer = "DependencyFactory"
    let postfix: String = isInterface ? "" : "Imp"
    let folderFullName = "\(name)\(layer)\(postfix)"
    return .project(target: folderFullName,
                    path: .relativeToRoot("DependencyFactory/\(name)/\(name)\(layer)"))
  }
}

extension TargetDependency {
  public static let Utility =  TargetDependency.project(target: "Utility", path: .relativeToRoot("Utility"))
  public static let LocalStorage = TargetDependency.project(target: "LocalStorage", path: .relativeToRoot("LocalStorage"))
  public static let GlobalState = TargetDependency.project(target: "GlobalState", path: .relativeToRoot("GlobalState"))
  public static let ResourceKit =  TargetDependency.project(target: "ResourceKit", path: .relativeToRoot("ResourceKit"))
  public static let DesignSystem =  TargetDependency.project(target: "DesignSystem", path: .relativeToRoot("DesignSystem"))
  public static let WalWalNetwork = TargetDependency.project(target: "WalWalNetwork", path: .relativeToRoot("WalWalNetwork"))
  
  public struct ThirdParty { }
  
  public struct DependencyFactory {
    public struct Splash: WalWalDependency { }
    public struct MyPage: WalWalDependency { }
    public struct Auth: WalWalDependency { }
    public struct Onboarding: WalWalDependency { }
    public struct WalWalTabBar: WalWalDependency { }
    public struct Mission: WalWalDependency { }
    public struct FCM: WalWalDependency { }
    public struct Records: WalWalDependency { }
    public struct Image: WalWalDependency { }
    public struct Feed: WalWalDependency { }
    public struct MissionUpload: WalWalDependency { }
    public struct Members: WalWalDependency { }
  }
  
  public struct Coordinator {
    public struct Base: WalWalDependency { }
    public struct App: WalWalDependency { }
    public struct WalWalTabBar: WalWalDependency { }
    public struct Auth: WalWalDependency { }
    public struct Onboarding: WalWalDependency { }
    public struct Mission: WalWalDependency { }
    public struct MyPage: WalWalDependency { }
    public struct Feed: WalWalDependency { }
    public struct MissionUpload: WalWalDependency { }
  }
  
  public struct Feature {
    public struct Splash {
      public struct Data: WalWalDependency {}
      public struct Domain: WalWalDependency {}
      public struct Presenter: WalWalDependency {}
    }
    
    public struct Auth {
      public struct Data: WalWalDependency {}
      public struct Domain: WalWalDependency {}
      public struct Presenter: WalWalDependency {}
    }
    
    public struct Onboarding {
      public struct Data: WalWalDependency {}
      public struct Domain: WalWalDependency {}
      public struct Presenter: WalWalDependency {}
    }
    
    public struct Mission {
      public struct Data: WalWalDependency {}
      public struct Domain: WalWalDependency {}
      public struct Presenter: WalWalDependency {}
    }
    
    public struct MyPage: WalWalDependency {
      public struct Data: WalWalDependency {}
      public struct Domain: WalWalDependency {}
      public struct Presenter: WalWalDependency {}
    }
    
    public struct Feed: WalWalDependency {
      public struct Data: WalWalDependency {}
      public struct Domain: WalWalDependency {}
      public struct Presenter: WalWalDependency {}
    }
    
    public struct FCM: WalWalDependency {
      public struct Data: WalWalDependency {}
      public struct Domain: WalWalDependency {}
    }
    
    public struct Records: WalWalDependency {
      public struct Data: WalWalDependency {}
      public struct Domain: WalWalDependency {}
    }
    
    public struct Image: WalWalDependency {
      public struct Data: WalWalDependency {}
      public struct Domain: WalWalDependency {}
    }
    
    public struct MissionUpload: WalWalDependency {
      public struct Domain: WalWalDependency {}
      public struct Presenter: WalWalDependency {}

    public struct Members: WalWalDependency {
      public struct Data: WalWalDependency { }
      public struct Domain: WalWalDependency { }
    }
  }
}

//MARK: - 여기서부터는, DependencyFactory별로 Dependency를 주입시키기 위한 준비

public extension TargetDependency.DependencyFactory.Splash {
  static let Interface = Self.project(dependencyName: .splash, isInterface: true)
  static let Implement = Self.project(dependencyName: .splash, isInterface: false)
}

public extension TargetDependency.DependencyFactory.Auth {
  static let Interface = Self.project(dependencyName: .auth, isInterface: true)
  static let Implement = Self.project(dependencyName: .auth, isInterface: false)
}

public extension TargetDependency.DependencyFactory.Onboarding {
  static let Interface = Self.project(dependencyName: .onboarding, isInterface: true)
  static let Implement = Self.project(dependencyName: .onboarding, isInterface: false)
}

public extension TargetDependency.DependencyFactory.WalWalTabBar {
  static let Interface = Self.project(dependencyName: .walwalTabBar, isInterface: true)
  static let Implement = Self.project(dependencyName: .walwalTabBar, isInterface: false)
}

public extension TargetDependency.DependencyFactory.Mission {
  static let Interface = Self.project(dependencyName: .mission, isInterface: true)
  static let Implement = Self.project(dependencyName: .mission, isInterface: false)
}

public extension TargetDependency.DependencyFactory.MyPage {
  static let Interface = Self.project(dependencyName: .myPage, isInterface: true)
  static let Implement = Self.project(dependencyName: .myPage, isInterface: false)
}

public extension TargetDependency.DependencyFactory.FCM {
  static let Interface = Self.project(dependencyName: .fcm, isInterface: true)
  static let Implement = Self.project(dependencyName: .fcm, isInterface: false)
}

public extension TargetDependency.DependencyFactory.Records {
  static let Interface = Self.project(dependencyName: .records, isInterface: true)
  static let Implement = Self.project(dependencyName: .records, isInterface: false)
}

public extension TargetDependency.DependencyFactory.Image {
  static let Interface = Self.project(dependencyName: .image, isInterface: true)
  static let Implement = Self.project(dependencyName: .image, isInterface: false)
}

public extension TargetDependency.DependencyFactory.Feed {
  static let Interface = Self.project(dependencyName: .feed, isInterface: true)
  static let Implement = Self.project(dependencyName: .feed, isInterface: false)
}

public extension TargetDependency.DependencyFactory.MissionUpload {
  static let Interface = Self.project(dependencyName: .missionUpload, isInterface: true)
  static let Implement = Self.project(dependencyName: .missionUpload, isInterface: false)

public extension TargetDependency.DependencyFactory.Members {
  static let Interface = Self.project(dependencyName: .members, isInterface: true)
  static let Implement = Self.project(dependencyName: .members, isInterface: false)
}

//MARK: - 여기서부터는, Feature별로 Dependency를 주입시키기 위한 준비

public extension TargetDependency.Feature.Splash.Presenter {
  static let Interface = Self.project(name: .splash, layer: .presenter, isInterface: true)
  static let Implement = Self.project(name: .splash, layer: .presenter, isInterface: false)
}

public extension TargetDependency.Feature.Splash.Domain {
  static let Interface = Self.project(name: .splash, layer: .domain, isInterface: true)
  static let Implement = Self.project(name: .splash, layer: .domain, isInterface: false)
}

public extension TargetDependency.Feature.Splash.Data {
  static let Interface = Self.project(name: .splash, layer: .data, isInterface: true)
  static let Implement = Self.project(name: .splash, layer: .data, isInterface: false)
}

public extension TargetDependency.Feature.Auth.Presenter {
  static let Interface = Self.project(name: .auth, layer: .presenter, isInterface: true)
  static let Implement = Self.project(name: .auth, layer: .presenter, isInterface: false)
}

public extension TargetDependency.Feature.Auth.Domain {
  static let Interface = Self.project(name: .auth, layer: .domain, isInterface: true)
  static let Implement = Self.project(name: .auth, layer: .domain, isInterface: false)
}

public extension TargetDependency.Feature.Auth.Data {
  static let Interface = Self.project(name: .auth, layer: .data, isInterface: true)
  static let Implement = Self.project(name: .auth, layer: .data, isInterface: false)
}

public extension TargetDependency.Feature.Onboarding.Presenter {
  static let Interface = Self.project(name: .onboarding, layer: .presenter, isInterface: true)
  static let Implement = Self.project(name: .onboarding, layer: .presenter, isInterface: false)
}

public extension TargetDependency.Feature.Onboarding.Domain {
  static let Interface = Self.project(name: .onboarding, layer: .domain, isInterface: true)
  static let Implement = Self.project(name: .onboarding, layer: .domain, isInterface: false)
}

public extension TargetDependency.Feature.Onboarding.Data {
  static let Interface = Self.project(name: .onboarding, layer: .data, isInterface: true)
  static let Implement = Self.project(name: .onboarding, layer: .data, isInterface: false)
}

public extension TargetDependency.Feature.Mission.Presenter {
  static let Interface = Self.project(name: .mission, layer: .presenter, isInterface: true)
  static let Implement = Self.project(name: .mission, layer: .presenter, isInterface: false)
}

public extension TargetDependency.Feature.Mission.Domain {
  static let Interface = Self.project(name: .mission, layer: .domain, isInterface: true)
  static let Implement = Self.project(name: .mission, layer: .domain, isInterface: false)
}

public extension TargetDependency.Feature.Mission.Data {
  static let Interface = Self.project(name: .mission, layer: .data, isInterface: true)
  static let Implement = Self.project(name: .mission, layer: .data, isInterface: false)
}

public extension TargetDependency.Feature.MyPage.Presenter {
  static let Interface = Self.project(name: .myPage, layer: .presenter, isInterface: true)
  static let Implement = Self.project(name: .myPage, layer: .presenter, isInterface: false)
}

public extension TargetDependency.Feature.MyPage.Domain {
  static let Interface = Self.project(name: .myPage, layer: .domain, isInterface: true)
  static let Implement = Self.project(name: .myPage, layer: .domain, isInterface: false)
}

public extension TargetDependency.Feature.MyPage.Data {
  static let Interface = Self.project(name: .myPage, layer: .data, isInterface: true)
  static let Implement = Self.project(name: .myPage, layer: .data, isInterface: false)
}

public extension TargetDependency.Feature.Feed.Presenter {
static let Interface = Self.project(name: .feed, layer: .presenter, isInterface: true)
static let Implement = Self.project(name: .feed, layer: .presenter, isInterface: false)
}

public extension TargetDependency.Feature.Feed.Domain {
static let Interface = Self.project(name: .feed, layer: .domain, isInterface: true)
static let Implement = Self.project(name: .feed, layer: .domain, isInterface: false)
}

public extension TargetDependency.Feature.Feed.Data {
static let Interface = Self.project(name: .feed, layer: .data, isInterface: true)
static let Implement = Self.project(name: .feed, layer: .data, isInterface: false)
}

public extension TargetDependency.Feature.FCM.Domain {
  static let Interface = Self.project(name: .fcm, layer: .domain, isInterface: true)
  static let Implement = Self.project(name: .fcm, layer: .domain, isInterface: false)
}

public extension TargetDependency.Feature.FCM.Data {
  static let Interface = Self.project(name: .fcm, layer: .data, isInterface: true)
  static let Implement = Self.project(name: .fcm, layer: .data, isInterface: false)
}

public extension TargetDependency.Feature.Records.Domain {
  static let Interface = Self.project(name: .records, layer: .domain, isInterface: true)
  static let Implement = Self.project(name: .records, layer: .domain, isInterface: false)
}

public extension TargetDependency.Feature.Records.Data {
  static let Interface = Self.project(name: .records, layer: .data, isInterface: true)
  static let Implement = Self.project(name: .records, layer: .data, isInterface: false)
}

public extension TargetDependency.Feature.Image.Domain {
  static let Interface = Self.project(name: .image, layer: .domain, isInterface: true)
  static let Implement = Self.project(name: .image, layer: .domain, isInterface: false)
}

public extension TargetDependency.Feature.Image.Data {
  static let Interface = Self.project(name: .image, layer: .data, isInterface: true)
  static let Implement = Self.project(name: .image, layer: .data, isInterface: false)
}

public extension TargetDependency.Feature.MissionUpload.Presenter {
  static let Interface = Self.project(name: .missionUpload, layer: .presenter, isInterface: true)
  static let Implement = Self.project(name: .missionUpload, layer: .presenter, isInterface: false)
}

public extension TargetDependency.Feature.MissionUpload.Domain {
  static let Interface = Self.project(name: .missionUpload, layer: .domain, isInterface: true)
  static let Implement = Self.project(name: .missionUpload, layer: .domain, isInterface: false)
}

public extension TargetDependency.Feature.Members.Domain {
  static let Interface = Self.project(name: .members, layer: .domain, isInterface: true)
  static let Implement = Self.project(name: .members, layer: .domain, isInterface: false)
}

public extension TargetDependency.Feature.Members.Data {
  static let Interface = Self.project(name: .members, layer: .data, isInterface: true)
  static let Implement = Self.project(name: .members, layer: .data, isInterface: false)
}
 
// MARK: - 여기서부터는, Coordinator별로 Dependency를 주입시키기 위한 준비

public extension TargetDependency.Coordinator.App {
  static let Interface = Self.project(name: .app, isInterface: true)
  static let Implement = Self.project(name: .app, isInterface: false)
}

public extension TargetDependency.Coordinator.WalWalTabBar {
  static let Interface = Self.project(name: .walwalTabBar, isInterface: true)
  static let Implement = Self.project(name: .walwalTabBar, isInterface: false)
}

public extension TargetDependency.Coordinator.Auth {
  static let Interface = Self.project(name: .auth, isInterface: true)
  static let Implement = Self.project(name: .auth, isInterface: false)
}

public extension TargetDependency.Coordinator.Onboarding {
  static let Interface = Self.project(name: .onboarding, isInterface: true)
  static let Implement = Self.project(name: .onboarding, isInterface: false)
}

public extension TargetDependency.Coordinator.Base {
  static let Interface = Self.project(name: .base, isInterface: true)
}

public extension TargetDependency.Coordinator.Mission {
  static let Interface = Self.project(name: .mission, isInterface: true)
  static let Implement = Self.project(name: .mission, isInterface: false)
}

public extension TargetDependency.Coordinator.MyPage {
  static let Interface = Self.project(name: .myPage, isInterface: true)
  static let Implement = Self.project(name: .myPage, isInterface: false)
}

public extension TargetDependency.Coordinator.Feed {
  static let Interface = Self.project(name: .feed, isInterface: true)
  static let Implement = Self.project(name: .feed, isInterface: false)
}

public extension TargetDependency.Coordinator.MissionUpload {
  static let Interface = Self.project(name: .missionUpload, isInterface: true)
  static let Implement = Self.project(name: .missionUpload, isInterface: false)
}

public extension TargetDependency.ThirdParty {
  private static func framework(name: String) -> TargetDependency {
    .xcframework(path: .relativeToRoot("Tuist/Dependencies/Carthage/Build/\(name).xcframework"), status: .optional)
  }
  
  static let RxAlamofire = TargetDependency.external(name: "RxAlamofire")
  static let ReactorKit = TargetDependency.external(name: "ReactorKit")
  static let RxSwift = TargetDependency.external(name: "RxSwift")
  static let RxRelay = TargetDependency.external(name: "RxRelay")
  static let RxCocoa = TargetDependency.external(name: "RxCocoa")
  static let RxGesture = TargetDependency.external(name: "RxGesture")
  static let Kingfisher = TargetDependency.external(name: "Kingfisher")
  static let Then = TargetDependency.external(name: "Then")
  static let KakaoSDKAuth = TargetDependency.external(name: "KakaoSDKAuth")
  static let KakaoSDKUser = TargetDependency.external(name: "KakaoSDKUser")
  static let KakaoSDKCommon = TargetDependency.external(name: "KakaoSDKCommon")
  static let FirebaseMessaging = TargetDependency.package(product: "FirebaseMessaging", type: .runtime)
  
  static let FlexLayout = framework(name: "FlexLayout")
  static let PinLayout = framework(name: "PinLayout")
}
