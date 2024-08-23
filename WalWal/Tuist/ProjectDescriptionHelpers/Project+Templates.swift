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

extension Target {
  
  //MARK: - App으로 Project를 만들기 위한 Target 생성
  public static func makeApp(
    name: String,
    platform: Platform,
    bundleId: String,
    iOSTargetVersion: String,
    infoPlistPath: String,
    excludeResourcePath: String,
    dependencies: [TargetDependency] = [],
    settings: Settings
  ) -> Target {
    let platform: Platform = platform
    let appTarget = Target(
      name: name,
      platform: platform,
      product: .app,
      bundleId: bundleId,
      deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: [.iphone]),
      infoPlist: .file(path: .relativeToRoot(infoPlistPath)),
      sources: ["Sources/**"],
      resources: [
        .glob(
          pattern: "Resources/**",
          excluding: [.init(excludeResourcePath)]
        )
      ],
      dependencies: dependencies,
      settings: settings
    )
    return appTarget
  }
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
                   targets: targetsForFramework,
                   resourceSynthesizers: .default + [
                    .custom(name: "Lottie", parser: .json, extensions: ["json"]),
                   ])
  }
  
  //MARK: - 빠르게 UI체크 할 DemoApp (Framework + App) -> Feature 단위로 테스트할 수 있게
  public static func DemoApp(
    name: String,
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
  
  
  /// 현재 경로 내부의 Implement, Interface 두개의 디렉토리에 각각 Target을 가지는 Project를 만듭니다.
  /// interface와 implement에 필요한 dependency를 각각 주입해줍니다.
  /// implement는 자동으로 interface에 대한 종속성을 가지고 있습니다.
  public static func invertedDualTargetProject(
    name: String,
    platform: Platform = .iOS,
    iOSTargetVersion: String = "16.0.0",
    interfaceDependencies: [TargetDependency] = [],
    implementDependencies: [TargetDependency] = [],
    infoPlist: InfoPlist = .default
  ) -> Project {
    
    let interfaceTarget = makeInterfaceDynamicFrameworkTarget(
      name: name,
      platform: platform,
      iOSTargetVersion: iOSTargetVersion,
      dependencies: interfaceDependencies
    )
    
    let implementTarget = makeImplementStaticLibraryTarget(
      name: name,
      platform: platform,
      iOSTargetVersion: iOSTargetVersion,
      dependencies: implementDependencies /*+ [.target(name: name)]*/
    )
    
    let targets: [Target] = [interfaceTarget, implementTarget]
    
    let settings: Settings = .settings(configurations: [
      .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
      .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
    ])
    
    return Project(name: name,
                   organizationName: organizationName,
                   settings: settings,
                   targets: targets)
  }
  
  /// 현재 경로 내부의 View, Reactor, DemoApp 세개의 디렉토리에 각각 Target을 가지는 Project를 만듭니다.
  public static func invertedPresenterWithDemoApp(
    name: String,
    platform: Platform = .iOS,
    iOSTargetVersion: String = "16.0.0",
    interfaceDependencies: [TargetDependency] = [],
    implementDependencies: [TargetDependency] = [],
    demoAppDependencies: [TargetDependency] = [],
    infoPlist: InfoPlist = .default
  ) -> Project {
    
    let interfaceTarget = makeInterfaceDynamicFrameworkTarget(
      name: name,
      platform: platform,
      iOSTargetVersion: iOSTargetVersion,
      dependencies: interfaceDependencies
    )
    
    let implementTarget = makeImplementStaticLibraryTarget(
      name: name,
      platform: platform,
      iOSTargetVersion: iOSTargetVersion,
      dependencies: implementDependencies /*+ [.target(name: name)]*/
    )
    
    let demoApp = Target(
      name: "\(name)DemoApp",
      platform: .iOS,
      product: .app,
      bundleId: "\(organizationName).\(name)Demoapp",
      deploymentTarget: .iOS(
        targetVersion: iOSTargetVersion,
        devices: [.iphone]
      ),
      infoPlist: infoPlist,
      sources: ["./DemoApp/Sources/**"],
      resources: ["./DemoApp/Resources/**"],
      dependencies: [
        //        .target(name: "\(name)"),
        //        .target(name: "\(name)Imp"),
      ] + demoAppDependencies
    )
    
    let targets: [Target] = [interfaceTarget, implementTarget, demoApp]
    let settings: Settings = .settings(configurations: [
      .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
      .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
    ])
    
    return Project(name: "\(name)",
                   organizationName: organizationName,
                   settings: settings,
                   targets: targets)
  }
}

private extension Project {
  
  private static func makeTarget(
    name: String,
    dependencies: [TargetDependency],
    iOSTargetVersion: String = "16.0.0"
  ) -> Target {
    return Target(name: name,
                  platform: .iOS,
                  product: .framework,
                  bundleId: "\(organizationName).\(name)",
                  deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: [.iphone]),
                  infoPlist: .default,
                  sources: ["./\(name)/**"],
                  dependencies: dependencies)
  }
  
  //MARK: - App으로 Project를 만들기 위한 Target 생성
  private static func makeAppTargets(
    name: String, platform: Platform,
    iOSTargetVersion: String,
    infoPlist: [String: Plist.Value],
    dependencies: [TargetDependency] = []
  ) -> [Target] {
    let platform: Platform = platform
    let appTarget = Target(name: name,
                           platform: platform,
                           product: .app,
                           bundleId: "\(organizationName).\(name)",
                           deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: [.iphone]),
                           infoPlist: .extendingDefault(with: infoPlist),
                           sources: ["Sources/**"],
                           resources: ["Resources/**"],
                           dependencies: dependencies)
    return [appTarget]
  }
  
  //MARK: - Framework로 Project를 만들기 위한 Target 생성
  private static func makeFrameworkTargets(
    name: String,
    platform: Platform,
    iOSTargetVersion: String,
    infoPlist: [String: Plist.Value] = [:],
    dependencies: [TargetDependency] = []
  ) -> [Target] {
    let sources = Target(name: name,
                         platform: platform,
                         product: .framework,
                         bundleId: "\(organizationName).framework.\(name)",
                         deploymentTarget: .iOS(
                          targetVersion: iOSTargetVersion,
                          devices: [.iphone]
                         ),
                         infoPlist: .extendingDefault(with: infoPlist),
                         sources: ["Sources/**"],
                         resources: ["Resources/**"],
                         dependencies: dependencies)
    return [sources]
  }
  
  //MARK: - Presenter/{{name}}View -> Framework로 만들기 위함
  private static func makeViewFrameworkTargets(
    name: String,
    platform: Platform,
    iOSTargetVersion: String,
    infoPlist: [String: Plist.Value] = [:],
    dependencies: [TargetDependency] = []
  ) -> Target {
    let target = Target(name: "\(name)View",
                        platform: platform,
                        product: .framework,
                        bundleId: "\(organizationName).\(name)View",
                        deploymentTarget: .iOS(
                          targetVersion: iOSTargetVersion,
                          devices: [.iphone]
                        ),
                        infoPlist: .extendingDefault(with: infoPlist),
                        
                        sources: ["./View/**"],
                        dependencies: dependencies)
    return target
  }
  
  //MARK: - Presenter/{{name}}Reactor -> Framework로 만들기 위함
  private static func makeReactorFrameworkTargets(
    name: String,
    platform: Platform,
    iOSTargetVersion: String,
    infoPlist: [String: Plist.Value] = [:],
    dependencies: [TargetDependency] = []
  ) -> Target {
    let target = Target(name: "\(name)Reactor",
                        platform: platform,
                        product: .framework,
                        bundleId: "\(organizationName).\(name)Reactor",
                        deploymentTarget: .iOS(
                          targetVersion: iOSTargetVersion,
                          devices: [.iphone]
                        ),
                        infoPlist: .extendingDefault(with: infoPlist),
                        sources: ["./Reactor/**"],
                        dependencies: dependencies)
    return target
  }
  
  // MARK: - Static Framework로 세팅할 Implementation Target 생성
  private static func makeImplementStaticLibraryTarget(
    name: String,
    platform: Platform,
    iOSTargetVersion: String,
    dependencies: [TargetDependency] = [],
    isUserInterface: Bool = false
  ) -> Target {
    
    return Target(name: "\(name)Imp",
                  platform: platform,
                  product: .staticFramework,
                  bundleId: "\(organizationName).\(name)",
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
  private static func makeInterfaceDynamicFrameworkTarget(
    name: String,
    platform: Platform,
    iOSTargetVersion: String,
    dependencies: [TargetDependency] = []
  ) -> Target {
    return Target(name: name,
                  platform: platform,
                  product: .framework,
                  bundleId: "\(organizationName).\(name)",
                  deploymentTarget: .iOS(
                    targetVersion: iOSTargetVersion,
                    devices: [.iphone]
                  ),
                  infoPlist: .default,
                  sources: ["./Interface/**"],
                  dependencies: dependencies)
  }
  
}
