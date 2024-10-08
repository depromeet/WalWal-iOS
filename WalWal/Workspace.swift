//
//  Workspace.swift
//  Config
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription

let workspace = Workspace(
  name: "WalWal",
  projects: [
    "./**"
  ],
  schemes: [
    Scheme(
      name: "DEV-WalWal",
      buildAction: .buildAction(targets: [.project(path: "./App", target: "DEV-WalWalApp")]),
      runAction: .runAction(configuration: .debug),
      archiveAction: .archiveAction(configuration: .debug),
      profileAction: .profileAction(configuration: .debug),
      analyzeAction: .analyzeAction(configuration: .debug)
    ),
    Scheme(
      name: "PROD-WalWal",
      buildAction: .buildAction(targets: [.project(path: "./App", target: "WalWal")]),
      runAction: .runAction(configuration: .release),
      archiveAction: .archiveAction(configuration: .release),
      profileAction: .profileAction(configuration: .release),
      analyzeAction: .analyzeAction(configuration: .release)
    )
  ],
  generationOptions: .options(autogeneratedWorkspaceSchemes: .disabled)
)
