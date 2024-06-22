//
//  App.swift
//  DependencyPlugin
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription

fileprivate let name: Template.Attribute = .required("name")
fileprivate let author: Template.Attribute = .required("author")

//MARK: - APP -> 최상단에서 모든 디펜던시를 주입 (실제 앱의 본체)
let App = Template(
  description: "App파일 만들 때 필요한 Templete",
  attributes: [
    name,
    author
  ],
  items: [
    .file(
        path: "App/Project.swift",
        templatePath: "AppProject.stencil"
    ),
    .file(
        path: "App/Sources/AppDelegate.swift",
        templatePath: "AppDelegate.stencil"
    ),
    .file(
        path: "App/Resources/LaunchScreen.storyboard",
        templatePath: "LaunchScreen.stencil"
    ),
    // 여기서부터는, Dependency를 주입시키기 위한 준비
    .file(
        path: "Tuist/ProjectDescriptionHelpers/Project+Templates.swift",
        templatePath: "Project+Templates.stencil"
    ),
    .file(
        path: "Tuist/Dependencies.swift",
        templatePath: "Dependencies.stencil"
    ),
    
  ]

)
