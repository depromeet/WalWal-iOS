//
//  DependencyFactory.swift
//  TemplatePlugin
//
//  Created by 조용인 on 7/24/24.
//

import ProjectDescription
import Foundation


fileprivate let name: Template.Attribute = .required("name")
fileprivate let author: Template.Attribute = .required("author")
fileprivate let currentDate: Template.Attribute = .optional("currentDate", default: DateFormatter().string(from: Date()))

let DependencyFactory = Template(
  description: "This Template is for making default files",
  attributes: [
    name,
    author,
    currentDate
  ],
  items: [
    //MARK: Coordinator Template Path
    .file(
      path: .DependencyFactoryBasePath + "/\(name)DependencyFactory/Project.swift",
      templatePath: "DependencyFactoryProject.stencil"
    ),
    .file(
      path: .DependencyFactoryBasePath + "/\(name)DependencyFactory/Interface/\(name)DependencyFactory.swift",
      templatePath: "DependencyFactoryInterface.stencil"
    ),
    .file(
      path: .DependencyFactoryBasePath + "/\(name)DependencyFactory/Implement/\(name)DependencyFactoryImp.swift",
      templatePath: "DependencyFactoryImplement.stencil"
    )
  ]
)

extension String {
  static var DependencyFactoryBasePath: Self {
    return "DependencyFactory/\(name)"
  }
}
