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
        .file(
            path: .featureBasePath + "/\(name)Data/Project.swift",
            templatePath: "DataLayer.stencil"
        ),
        .file(
            path: .featureBasePath + "/\(name)Data/Interface/Project.swift",
            templatePath: "dummy.stencil"
        ),
        .file(
            path: .featureBasePath + "/\(name)Data/Implement/Project.swift",
            templatePath: "dummy.stencil"
        ),
        .file(
            path: .featureBasePath + "/\(name)Domain/Project.swift",
            templatePath: "DomainLayer.stencil"
        ),
        .file(
            path: .featureBasePath + "/\(name)Domain/Interface/Project.swift",
            templatePath: "dummy.stencil"
        ),
        .file(
            path: .featureBasePath + "/\(name)Domain/Implement/Project.swift",
            templatePath: "dummy.stencil"
        ),
        .file(
            path: .featureBasePath + "/\(name)Presenter/View/Project.swift",
            templatePath: "View.stencil"
        ),
        .file(
            path: .featureBasePath + "/\(name)Presenter/Reactor/Project.swift",
            templatePath: "Reactor.stencil"
        ),
        //MARK: - DemoApp
        .file(
            path: .featureBasePath + "/\(name)Presenter/DemoApp/Sources/\(name)UserInterfaceAppDelegate.swift",
            templatePath: "AppDelegate.stencil"
        ),
        .file(
            path: .featureBasePath + "/\(name)Presenter/DemoApp/Resources/LaunchScreen.storyboard",
            templatePath: "LaunchScreen.stencil"
        ),
        .file(
            path: .featureBasePath + "/\(name)Presenter/DemoApp/Sources/\(name)UserInterfaceViewController.swift",
            templatePath: "ViewController.stencil"
        )
    ]
)

extension String {
    static var featureBasePath: Self {
        return "Features/\(name)"
    }
}
