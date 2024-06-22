//
//  Dependencies.swift
//  Config
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription

let spm = SwiftPackageManagerDependencies(
  [
    .remote(url: "https://github.com/ReactiveX/RxSwift",
            requirement: .upToNextMajor(from:"6.0.0")),
    .remote(url: "https://github.com/RxSwiftCommunity/RxGesture",
            requirement: .upToNextMinor(from: "4.0.0")),
    .remote(url: "https://github.com/ReactorKit/ReactorKit",
            requirement: .upToNextMajor(from: "3.2.0")),
    .remote(url: "https://github.com/onevcat/Kingfisher",
            requirement: .upToNextMajor(from: "7.12.0")),
    .remote(url: "https://github.com/devxoul/Then",
            requirement: .upToNextMajor(from: "2.0.0")),
    .remote(url: "https://github.com/layoutBox/FlexLayout",
            requirement: .upToNextMajor(from: "1.3.18")),
    .remote(url: "https://github.com/layoutBox/PinLayout",
            requirement: .upToNextMajor(from: "1.10.1"))
  ],
  productTypes: [
    "Alamofire": .framework,
    "ReactorKit": .framework,
    "RxSwift": .framework,
    "RxCocoa": .framework,
    "RxRelay": .framework,
    "RxGesture": .framework,
    "Kingfisher": .framework,
    "Then": .framework,
    "FlexLayout": .framework,
    "PinLayout": .framework
  ]
)

let dependencies = Dependencies(
  swiftPackageManager: spm,
  platforms: [.iOS]
)
