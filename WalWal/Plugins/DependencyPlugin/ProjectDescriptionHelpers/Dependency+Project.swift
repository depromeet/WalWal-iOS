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

enum CoordinatorStr: String {
  case base = "Base"
  case sampleAuth = "SampleAuth"
  case sampleApp = "SampleApp"
  case sampleHome = "SampleHome"
}

enum Reactor: String {
  case reactor = "Reactor"
  case view = "View"
}

enum FeatureStr: String {
  case auth = "Auth"
  case sample = "Sample"
}

protocol WalWalDependency {
  static func project(name: FeatureStr, layer: Layer, isInterface: Bool) -> TargetDependency
  static func project(name: FeatureStr, layer: Layer, type: Reactor) -> TargetDependency
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
  
  static func project(name: FeatureStr, layer: Layer, type: Reactor) -> TargetDependency {
    let name = name.rawValue
    let layer = layer.rawValue
    let type = type.rawValue
    let folderFullName = "\(name)\(layer)\(type)"
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
}

extension TargetDependency {
  public static let Utility =  TargetDependency.project(target: "Utility", path: .relativeToRoot("Utility"))
  public static let LocalStorage = TargetDependency.project(target: "LocalStorage", path: .relativeToRoot("LocalStorage"))
  public static let ResourceKit =  TargetDependency.project(target: "ResourceKit", path: .relativeToRoot("ResourceKit"))
  public static let DesignSystem =  TargetDependency.project(target: "DesignSystem", path: .relativeToRoot("DesignSystem"))
  
  public struct Coordinator {
    public struct Base: WalWalDependency { }
    public struct SampleAuth: WalWalDependency { }
    public struct SampleApp: WalWalDependency { }
    public struct SampleHome: WalWalDependency { }
  }
  
  public struct DependencyFactory { }
  
  public struct WalWalNetwork { }
  
  public struct ThirdParty { }
  
  public struct Feature {
    public struct Auth: WalWalDependency {
      public struct Data {}
      public struct Domain {}
      public struct Presenter {}
    }
    
    public struct Sample: WalWalDependency {
      public struct Data {}
      public struct Domain {}
      public struct Presenter {}
    }
  }
}

//MARK: - 여기서부터는, Feature별로 Dependency를 주입시키기 위한 준비
public extension TargetDependency.Feature.Auth.Presenter {
  static let View = TargetDependency.Feature.Auth.project(name: .auth,
                                                          layer: .presenter,
                                                          type: .view)
  
  static let Reactor = TargetDependency.Feature.Auth.project(name: .auth,
                                                             layer: .presenter,
                                                             type: .reactor)
}

public extension TargetDependency.Feature.Auth.Domain {
  static let Interface = TargetDependency.Feature.Auth.project(name: .auth,
                                                               layer: .domain,
                                                               isInterface: true)
  
  static let Implement = TargetDependency.Feature.Auth.project(name: .auth,
                                                               layer: .domain,
                                                               isInterface: false)
}

public extension TargetDependency.Feature.Auth.Data {
  static let Interface = TargetDependency.Feature.Sample.project(name: .auth,
                                                                 layer: .data,
                                                                 isInterface: true)
  
  static let Implement = TargetDependency.Feature.Sample.project(name: .auth,
                                                                 layer: .data,
                                                                 isInterface: false)
}

public extension TargetDependency.Feature.Sample.Presenter {
  static let View = TargetDependency.Feature.Sample.project(name: .sample,
                                                            layer: .presenter,
                                                            type: .view)
  
  static let Reactor = TargetDependency.Feature.Sample.project(name: .sample,
                                                               layer: .presenter,
                                                               type: .reactor)
}

public extension TargetDependency.Feature.Sample.Domain {
  static let Interface = TargetDependency.Feature.Sample.project(name: .sample,
                                                                 layer: .domain,
                                                                 isInterface: true)
  
  static let Implement = TargetDependency.Feature.Sample.project(name: .sample,
                                                                 layer: .domain,
                                                                 isInterface: false)
}

public extension TargetDependency.Feature.Sample.Data {
  static let Interface = TargetDependency.Feature.Sample.project(name: .sample,
                                                                 layer: .data,
                                                                 isInterface: true)
  
  static let Implement = TargetDependency.Feature.Sample.project(name: .sample,
                                                                 layer: .data,
                                                                 isInterface: false)
}

// MARK: - 여기서부터는, Coordinator별로 Dependency를 주입시키기 위한 준비
public extension TargetDependency.Coordinator.SampleApp {
  static let Interface = TargetDependency.Coordinator.SampleApp.project(name: .sampleApp,
                                                                        isInterface: true)
  static let Implement = TargetDependency.Coordinator.SampleApp.project(name: .sampleApp,
                                                                        isInterface: false)
}

public extension TargetDependency.Coordinator.SampleAuth {
  static let Interface = TargetDependency.Coordinator.SampleAuth.project(name: .sampleAuth,
                                                                        isInterface: true)
  static let Implement = TargetDependency.Coordinator.SampleAuth.project(name: .sampleAuth,
                                                                        isInterface: false)
}

public extension TargetDependency.Coordinator.SampleHome {
  static let Interface = TargetDependency.Coordinator.SampleHome.project(name: .sampleHome,
                                                                        isInterface: true)
  static let Implement = TargetDependency.Coordinator.SampleHome.project(name: .sampleHome,
                                                                        isInterface: false)
}

public extension TargetDependency.Coordinator.Base {
  static let Interface = TargetDependency.Coordinator.SampleHome.project(name: .base,
                                                                        isInterface: true)
  static let Implement = TargetDependency.Coordinator.SampleHome.project(name: .base,
                                                                        isInterface: false)
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

public extension TargetDependency.WalWalNetwork {
  static let Interface = TargetDependency.project(target: "WalWalNetwork", path: .relativeToRoot("WalWalNetwork"))
  static let Implement = TargetDependency.project(target: "WalWalNetworkImp", path: .relativeToRoot("WalWalNetwork"))
}

public extension TargetDependency.DependencyFactory {
  static let Interface = TargetDependency.project(target: "DependencyFactory", path: .relativeToRoot("DependencyFactory"))
  static let Implement = TargetDependency.project(target: "DependencyFactoryImp", path: .relativeToRoot("DependencyFactory"))
}

