//
//  Coordinator.swift
//  TemplatePlugin
//
//  Created by 조용인 on 7/15/24.
//

import ProjectDescription
import Foundation


fileprivate let name: Template.Attribute = .required("name")
fileprivate let author: Template.Attribute = .required("author")
fileprivate let currentDate: Template.Attribute = .optional("currentDate", default: DateFormatter().string(from: Date()))

let Coordinator = Template(
  description: "This Template is for making default files",
  attributes: [
    name,
    author,
    currentDate
  ],
  items: [
    //MARK: Coordinator Template Path
    .file(
      path: .featureBasePath + "/\(name)Coordinator/Project.swift",
      templatePath: "DataProject.stencil"
    ),
    .file(
      path: .featureBasePath + "/\(name)Coordinator/Interface/\(name)CoordinatorInterface.swift",
      templatePath: "DataInterface.stencil"
    ),
    .file(
      path: .featureBasePath + "/\(name)Coordinator/Implement/\(name)CoordinatorImplement.swift",
      templatePath: "DataImplement.stencil"
    )
  ]
)

extension String {
  static var CoordinatorBasePath: Self {
    return "Coordinators/\(name)"
  }
}
