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

enum FeatureStr: String {
  case auth = "Auth"
}

protocol WalWalDependency {
  /// Feature Dependency 전용입니다.
  static func project(name: FeatureStr, layer: Layer, isInterface: Bool) -> TargetDependency
}

extension WalWalDependency {
  
  static func project(name: FeatureStr, layer: Layer, isInterface: Bool) -> TargetDependency {
    let postfix: String = isInterface ? "" : "Impl"
    let layer = layer.rawValue
    let name = name.rawValue
    let folderFullName = "\(name)\(layer)\(postfix)"
    return .project(target: name,
                    path: .relativeToRoot("Feature/\(name)/\(folderFullName)"))
  }
  
}

extension TargetDependency {
  // - 독립모듈도 의존성을 분리시킬 필요가 있다면, interface 고민해보기
  public static let Utility =  TargetDependency.project(target: "Utility", path: .relativeToRoot("Utility"))
  public static let WALWALNetwork =  TargetDependency.project(target: "WALWALNetwork", path: .relativeToRoot("WALWALNetwork"))
  public static let ResourceKit =  TargetDependency.project(target: "ResourceKit", path: .relativeToRoot("ResourceKit"))
  public static let DesignSystem =  TargetDependency.project(target: "DesignSystem", path: .relativeToRoot("DesignSystem"))
  
  public struct Feature {
    public struct Auth: WalWalDependency {
      public struct Data {}
      public struct Domain {}
      public struct Presenter {}
    }
  }
  
  public struct ThirdParty { }
}

//MARK: - 여기서부터는, Feature별로 Dependency를 주입시키기 위한 준비
public extension TargetDependency.Feature.Auth.Presenter {
  static let interface = TargetDependency.Feature.Auth.project(name: .auth,
                                                               layer: .presenter,
                                                               isInterface: true)
  
  static let implement = TargetDependency.Feature.Auth.project(name: .auth,
                                                               layer: .presenter,
                                                               isInterface: false)
}

public extension TargetDependency.Feature.Auth.Domain {
  static let interface = TargetDependency.Feature.Auth.project(name: .auth,
                                                               layer: .domain,
                                                               isInterface: true)
  
  static let implement = TargetDependency.Feature.Auth.project(name: .auth,
                                                               layer: .domain,
                                                               isInterface: false)
}

public extension TargetDependency.Feature.Auth.Data {
  static let interface = TargetDependency.Feature.Auth.project(name: .auth,
                                                               layer: .data,
                                                               isInterface: true)
  
  static let implement = TargetDependency.Feature.Auth.project(name: .auth,
                                                               layer: .data,
                                                               isInterface: false)
}

public extension TargetDependency.ThirdParty {
  static let Alamofire = TargetDependency.external(name: "Alamofire")
  static let ReactorKit = TargetDependency.external(name: "ReactorKit")
  static let RxSwift = TargetDependency.external(name: "RxSwift")
  static let RxRelay = TargetDependency.external(name: "RxRelay")
  static let RxCocoa = TargetDependency.external(name: "RxCocoa")
  static let RxGesture = TargetDependency.external(name: "RxGesture")
  static let Kingfisher = TargetDependency.external(name: "Kingfisher")
  static let Then = TargetDependency.external(name: "Then")
  static let FlexLayout = TargetDependency.external(name: "FlexLayout")
  static let PinLayout = TargetDependency.external(name: "PinLayout")
}
