//
//  Dependencies.swift
//  Config
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription


let carthages = CarthageDependencies([
  .github(
    path: "layoutBox/PinLayout",
    requirement: .upToNext("1.10.1")
  ),
  .github(
    path: "layoutBox/FlexLayout",
    requirement: .upToNext("1.3.18")
  ),
])


let spm = SwiftPackageManagerDependencies(
  [
    .remote(url: "https://github.com/ReactiveX/RxSwift",
            requirement: .upToNextMajor(from:"6.0.0")),
    .remote(url: "https://github.com/RxSwiftCommunity/RxGesture",
            requirement: .upToNextMinor(from: "4.0.0")),
    .remote(url: "https://github.com/ReactorKit/ReactorKit",
            requirement: .upToNextMajor(from: "3.2.0")),
    .remote(url: "https://github.com/RxSwiftCommunity/RxAlamofire",
            requirement: .upToNextMajor(from: "6.1.0")),
    .remote(url: "https://github.com/onevcat/Kingfisher",
            requirement: .upToNextMajor(from: "7.12.0")),
    .remote(url: "https://github.com/devxoul/Then",
            requirement: .upToNextMajor(from: "2.0.0")),
    .remote(url: "https://github.com/kakao/kakao-ios-sdk",
            requirement: .upToNextMajor(from: "2.22.4"))
  ],
  productTypes: [
    "RxAlamofire": .framework,
    "ReactorKit": .framework,
    "RxSwift": .framework,
    "RxCocoa": .framework,
    "RxRelay": .framework,
    "RxGesture": .framework,
    "Kingfisher": .framework,
    "Then": .framework,
    "KakaoSDKAuth": .framework,
    "KakaoSDKUser": .framework
  ]
)

let dependencies = Dependencies(
  carthage: carthages,
  swiftPackageManager: spm,
  platforms: [.iOS]
)
