import ProjectDescription

// 이곳에서, Tuist설정을 더 쉽게 관리할 수 있도록 일반적인 프로젝트 설정과관련된 공통 기능을 캡슐화 하는 파일
/// Project+Templetes는 이름대로, 각 Target(모듈)에 적용할 설정을 템플릿화하여 관리하는 파일임. (Project파일 커스텀 하는 곳)

// 자자 우리가 ReactorKit + Clean Architecture를 적용한다면 ???
// -> Presenter제외 모든 파트를 Interface & Implementation으로 나눠서 관리.

// Ex. 인터페이스들은 모두 Dynamic Framework로 설정 (여러곳에서 중복 사용 가능)
// Ex. 구현부(Implementation)들은 모두 Static Framework로 설정 (이미 구현된 내용은 중복 사용X)

// Ex. AppTarget 설정. (product타입이 .app인 것들,,, ex. DemoApp / MainApp)
// -> Demo App: Feature 단위의 빠른 테스트를 위함. (Ex. 로그인쪽 화면만 따로 테스트하고 싶다던지 ~)

extension Project {
  private static let organizationName = "olderStoneBed.io"
}


//MARK: -
extension Project {
  //MARK: - 실제로 Application으로 뽑아낼 Project
  public static func app(name: String,
                         platform: Platform,
                         infoPlist: [String: Plist.Value],
                         iOSTargetVersion: String,
                         dependencies: [TargetDependency] = []) -> Project {
   let targetsForApp = makeAppTargets(name: name,
                                platform: platform,
                                iOSTargetVersion: iOSTargetVersion,
                                infoPlist: infoPlist,
                                dependencies: dependencies)
    return Project(name: name,
                   organizationName: organizationName,
                   targets: targetsForApp)
  }
  
  //MARK: - 실제로 Framework로 뽑아낼 Project
  public static func framework(name: String,
                               platform: Platform,
                               infoPlist: [String: Plist.Value] = [:],
                               iOSTargetVersion: String,
                               dependencies: [TargetDependency] = []) -> Project {
      let targetsForFramework = makeFrameworkTargets(name: name,
                                         platform: platform,
                                         iOSTargetVersion: iOSTargetVersion,
                                         infoPlist: infoPlist,
                                         dependencies: dependencies)
      return Project(name: name,
                     organizationName: organizationName,
                     targets: targetsForFramework)
  }
  
  //MARK: - 빠르게 UI체크 할 DemoApp (Framework + App) -> Feature 단위로 테스트할 수 있게
  public static func DemoApp(name: String,
                             platform: Platform,
                             iOSTargetVersion: String,
                             infoPlist: [String: Plist.Value] = [:],
                             dependencies: [TargetDependency] = []) -> Project {
    let framework = makeFrameworkTargets(name: name,
                                         platform: platform,
                                         iOSTargetVersion: iOSTargetVersion,
                                         dependencies: dependencies)
    
    let demoApp =  makeAppTargets(name: "\(name)DemoApp",
                                  platform: platform,
                                  iOSTargetVersion: iOSTargetVersion,
                                  infoPlist: infoPlist,
                                  dependencies: [.target(name: name)] + dependencies)
    return Project(name: name,
                   organizationName: organizationName,
                   targets: framework + demoApp)
  }
  
  
  
  
}



private extension Project {
  
  public static func makeTarget(
      name: String,
      dependencies: [TargetDependency],
      iOSTargetVersion: String = "16.0.0"
  ) -> Target {
      return Target(name: name,
             platform: .iOS,
             product: .framework,
             bundleId: "olderStoneBed.io.\(name)",
             deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: [.iphone]),
             infoPlist: .default,
             sources: ["./\(name)/**"],
             dependencies: dependencies)
  }
  
  //MARK: - App으로 Project를 만들기 위한 Target 생성
  static func makeAppTargets(
    name: String, platform: Platform,
    iOSTargetVersion: String,
    infoPlist: [String: Plist.Value],
    dependencies: [TargetDependency] = []
  ) -> [Target] {
    let platform: Platform = platform
    let appTarget = Target(name: name,
                           platform: platform,
                           product: .app,
                           bundleId: "olderStoneBed.io.\(name)",
                           deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: [.iphone]),
                           infoPlist: .extendingDefault(with: infoPlist),
                           sources: ["Sources/**"],
                           resources: ["Resources/**"],
                           dependencies: dependencies)
    return [appTarget]
  }
  
  //MARK: - Framework로 Project를 만들기 위한 Target 생성
  static func makeFrameworkTargets(
    name: String,
    platform: Platform,
    iOSTargetVersion: String,
    infoPlist: [String: Plist.Value] = [:],
    dependencies: [TargetDependency] = []
  ) -> [Target] {
    let sources = Target(name: name,
                         platform: platform,
                         product: .framework,
                         bundleId: "olderStoneBed.io.\(name)",
                         deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: [.iphone]),
                         infoPlist: .extendingDefault(with: infoPlist),
                         sources: ["Sources/**"],
                         resources: ["Resources/**"],
                         dependencies: dependencies)
    return [sources]
  }
  
  // MARK: - Static Framework로 세팅할 Implementation Target 생성
  static func makeImplementStaticLibraryTarget(
      name: String,
      platform: Platform,
      iOSTargetVersion: String,
      dependencies: [TargetDependency] = [],
      isUserInterface: Bool = false
  ) -> Target {
      
      return Target(name: "\(name)Impl",
                    platform: platform,
                    product: .staticFramework,
                    bundleId: "team.io.\(name)",
                    deploymentTarget: .iOS(
                      targetVersion: iOSTargetVersion,
                      devices: [.iphone]
                    ),
                    infoPlist: .default,
                    sources: ["./Implement/**"],
                    dependencies: dependencies
      )
  }
  
  // MARK: - Dynamic Framework로 세팅할 Interface Target 생성
  static func makeInterfaceDynamicFrameworkTarget(
      name: String,
      platform: Platform,
      iOSTargetVersion: String,
      dependencies: [TargetDependency] = []
  ) -> Target {
      return Target(name: name,
                    platform: platform,
                    product: .framework,
                    bundleId: "team.io.\(name)",
                    deploymentTarget: .iOS(
                      targetVersion: iOSTargetVersion,
                      devices: [.iphone]
                    ),
                    infoPlist: .default,
                    sources: ["./Interface/**"],
                    dependencies: dependencies)
  }
  
}
