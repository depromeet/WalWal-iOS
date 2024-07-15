//
//  Workspace.swift
//  Config
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription

let appName = "WalWal"

let workspace = Workspace(
  name: appName,
  projects: [
    "./**"
  ]
)
