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

let Coordinators = Template(
  description: "This Template is for making default files",
  attributes: [
    name,
    author,
    currentDate
  ],
  items: [
    //MARK: Coordinator Template Path
    .file(
      path: .CoordinatorBasePath + "/\(name)Coordinator/Project.swift",
      templatePath: "CoordinatorProject.stencil"
    ),
    .file(
      path: .CoordinatorBasePath + "/\(name)Coordinator/Interface/\(name)Coordinator.swift",
      templatePath: "CoordinatorInterface.stencil"
    ),
    .file(
      path: .CoordinatorBasePath + "/\(name)Coordinator/Implement/\(name)CoordinatorImpl.swift",
      templatePath: "CoordinatorImplement.stencil"
    )
  ]
)

extension String {
  static var CoordinatorBasePath: Self {
    return "Coordinators/\(name)"
  }
}
