//
//  Feature.swift
//  DependencyPlugin
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription
import Foundation


fileprivate let name: Template.Attribute = .required("name")
fileprivate let author: Template.Attribute = .required("author")
fileprivate let currentDate: Template.Attribute = .optional("currentDate", default: DateFormatter().string(from: Date()))

let Feature = Template(
  description: "This Template is for making default files",
  attributes: [
    name,
    author,
    currentDate
  ],
  items: [
    //MARK: Data Layer
    .file(
      path: .featureBasePath + "/\(name)Data/Project.swift",
      templatePath: "DataProject.stencil"
    ),
    .file(
      path: .featureBasePath + "/\(name)Data/Interface/\(name)DataInterface.swift",
      templatePath: "DataInterface.stencil"
    ),
    .file(
      path: .featureBasePath + "/\(name)Data/Implement/\(name)DataImplement.swift",
      templatePath: "DataImplement.stencil"
    ),
    .file(
      path: .featureBasePath + "/\(name)Data/DTO/\(name)DTO.swift",
      templatePath: "DTO.stencil"
    ),
    //MARK: Domain Layer
    .file(
      path: .featureBasePath + "/\(name)Domain/Project.swift",
      templatePath: "DomainProject.stencil"
    ),
    .file(
      path: .featureBasePath + "/\(name)Domain/Interface/\(name)DomainInterface.swift",
      templatePath: "DomainInterface.stencil"
    ),
    .file(
      path: .featureBasePath + "/\(name)Domain/Implement/\(name)DomainImplement.swift",
      templatePath: "DomainImplement.stencil"
    ),
    .file(
      path: .featureBasePath + "/\(name)Domain/Model/\(name)Model.swift",
      templatePath: "Model.stencil"
    ),
    //MARK: Presenter Layer
    .file(
      path: .featureBasePath + "/\(name)Presenter/Project.swift",
      templatePath: "PresenterProject.stencil"
    ),
    .file(
      path: .featureBasePath + "/\(name)Presenter/View/\(name)View.swift",
      templatePath: "View.stencil"
    ),
    .file(
      path: .featureBasePath + "/\(name)Presenter/Reactor/\(name)Reactor.swift",
      templatePath: "Reactor.stencil"
    ),
    //MARK: - DemoApp
    .file(
      path: .featureBasePath + "/\(name)Presenter/DemoApp/Sources/\(name)DemoAppDelegate.swift",
      templatePath: "AppDelegate.stencil"
    ),
    .file(
      path: .featureBasePath + "/\(name)Presenter/DemoApp/Resources/LaunchScreen.storyboard",
      templatePath: "LaunchScreen.stencil"
    )
  ]
)

extension String {
  static var featureBasePath: Self {
    return "Features/\(name)"
  }
}
