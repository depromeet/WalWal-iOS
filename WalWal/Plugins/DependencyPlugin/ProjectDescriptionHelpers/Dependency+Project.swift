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
  case sample = "Sample"
}

enum CoordinatorStr: String {
  case base = "Base"
  case app = "App"
  case sampleAuth = "SampleAuth"
  case sampleApp = "SampleApp"
  case sampleHome = "SampleHome"
  case auth = "Auth"
}

enum FeatureStr: String {
  case splash = "Splash"
  case auth = "Auth"
  case sample = "Sample"
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
  public static let ResourceKit =  TargetDependency.project(target: "ResourceKit", path: .relativeToRoot("ResourceKit"))
  public static let DesignSystem =  TargetDependency.project(target: "DesignSystem", path: .relativeToRoot("DesignSystem"))
  public static let WalWalNetwork = TargetDependency.project(target: "WalWalNetwork", path: .relativeToRoot("WalWalNetwork"))
  
  public struct ThirdParty { }
  
  public struct DependencyFactory {
    public struct Splash: WalWalDependency { }
    public struct Sample: WalWalDependency { }
    public struct Auth: WalWalDependency { }
  }
  
  public struct Coordinator {
    public struct Base: WalWalDependency { }
    public struct App: WalWalDependency { }
    public struct SampleAuth: WalWalDependency { }
    public struct SampleApp: WalWalDependency { }
    public struct SampleHome: WalWalDependency { }
    public struct Auth: WalWalDependency { }
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
    
    public struct Sample {
      public struct Data: WalWalDependency {}
      public struct Domain: WalWalDependency {}
      public struct Presenter: WalWalDependency {}
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

public extension TargetDependency.DependencyFactory.Sample {
  static let Interface = Self.project(dependencyName: .sample, isInterface: true)
  static let Implement = Self.project(dependencyName: .sample, isInterface: false)
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

public extension TargetDependency.Feature.Sample.Presenter {
  static let Interface = Self.project(name: .sample, layer: .presenter, isInterface: true)
  static let Implement = Self.project(name: .sample, layer: .presenter, isInterface: false)
}

public extension TargetDependency.Feature.Sample.Domain {
  static let Interface = Self.project(name: .sample, layer: .domain, isInterface: true)
  static let Implement = Self.project(name: .sample, layer: .domain, isInterface: false)
}

public extension TargetDependency.Feature.Sample.Data {
  static let Interface = Self.project(name: .sample, layer: .data, isInterface: true)
  static let Implement = Self.project(name: .sample, layer: .data, isInterface: false)
}

// MARK: - 여기서부터는, Coordinator별로 Dependency를 주입시키기 위한 준비
public extension TargetDependency.Coordinator.SampleApp {
  static let Interface = Self.project(name: .sampleApp, isInterface: true)
  static let Implement = Self.project(name: .sampleApp, isInterface: false)
}

public extension TargetDependency.Coordinator.SampleAuth {
  static let Interface = Self.project(name: .sampleAuth, isInterface: true)
  static let Implement = Self.project(name: .sampleAuth, isInterface: false)
}

public extension TargetDependency.Coordinator.SampleHome {
  static let Interface = Self.project(name: .sampleHome, isInterface: true)
  static let Implement = Self.project(name: .sampleHome, isInterface: false)
}

public extension TargetDependency.Coordinator.App {
  static let Interface = Self.project(name: .app, isInterface: true)
  static let Implement = Self.project(name: .app, isInterface: false)
}

public extension TargetDependency.Coordinator.Auth {
  static let Interface = Self.project(name: .auth, isInterface: true)
  static let Implement = Self.project(name: .auth, isInterface: false)
}

public extension TargetDependency.Coordinator.Base {
  static let Interface = Self.project(name: .base, isInterface: true)
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
  
  static let FlexLayout = framework(name: "FlexLayout")
  static let PinLayout = framework(name: "PinLayout")
}
