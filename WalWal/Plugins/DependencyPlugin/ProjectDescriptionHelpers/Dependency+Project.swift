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

enum Reactor: String {
  case reactor = "Reactor"
  case view = "View"
}

enum FeatureStr: String {
  case auth = "Auth"
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
    return .project(target: "\(folderFullName)",
                    path: .relativeToRoot("Features/\(name)/\(name)\(layer)"))
  }
  
  static func project(name: FeatureStr, layer: Layer, type: Reactor) -> TargetDependency {
    let name = name.rawValue
    let layer = layer.rawValue
    let type = type.rawValue
    let folderFullName = "\(name)\(layer)\(type)"
    return .project(target: "\(folderFullName)",
                    path: .relativeToRoot("Features/\(name)/\(name)\(layer)"))
  }
  
}

extension TargetDependency {
  // - 독립모듈도 의존성을 분리시킬 필요가 있다면, interface 고민해보기
  public static let Utility =  TargetDependency.project(target: "Utility", path: .relativeToRoot("Utility"))
  public static let ResourceKit =  TargetDependency.project(target: "ResourceKit", path: .relativeToRoot("ResourceKit"))
  public static let DesignSystem =  TargetDependency.project(target: "DesignSystem", path: .relativeToRoot("DesignSystem"))
  
  public struct Network { }
  
  public struct ThirdParty { }
  
  public struct Feature {
    public struct Auth: WalWalDependency {
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
  static let Interface = TargetDependency.Feature.Auth.project(name: .auth,
                                                               layer: .data,
                                                               isInterface: true)
  
  static let Implement = TargetDependency.Feature.Auth.project(name: .auth,
                                                               layer: .data,
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

public extension TargetDependency.Network {
    static let Interface = TargetDependency.project(target: "Network", path: .relativeToRoot("Network"))
    static let Implement = TargetDependency.project(target: "NetworkImp", path: .relativeToRoot("Network"))
}
