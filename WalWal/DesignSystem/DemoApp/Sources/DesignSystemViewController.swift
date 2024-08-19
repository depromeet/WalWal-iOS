//
//  DesignSystemViewController.swift
//  DesignSystemDemoApp
//
//  Created by 조용인 on 7/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

fileprivate enum DesignSystemType: String, CaseIterable {
  case WalWalCalendar
  case WalWalNavigation
  case WalWalTouchArea
  case WalWalChip
  case WalWalProfileCardView
  case WalWalInputBox
  case WalWalFeed
  case WalWalButton
  case WalWalProfile
  case WalWalToast
}

final class DesignSystemViewController: UITableViewController {
  
  private var designSystems: [DesignSystemType] = DesignSystemType.allCases
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return designSystems.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = self.designSystems[indexPath.item].rawValue
    return cell
  }
  
  override func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 50
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let designSystem = self.designSystems[indexPath.item]
    switch designSystem {
    case .WalWalCalendar:
      self.navigationController?.pushViewController(WalWalCalenderDemoViewController(), animated: true)
    case .WalWalNavigation:
      self.navigationController?.pushViewController(WalWalNavigationBarDemoViewController(), animated: true)
    case .WalWalTouchArea:
      self.navigationController?.pushViewController(WalWalTouchAreaDemoViewController(), animated: true)
    case .WalWalChip:
      self.navigationController?.pushViewController(WalWalChipDemoViewController(), animated: true)
    case .WalWalProfileCardView:
      self.navigationController?.pushViewController(WalWalProfileCardDemoViewController(), animated: true)
    case .WalWalInputBox:
      self.navigationController?.pushViewController(WalWalInputBoxDemoViewController(), animated: true)
    case .WalWalFeed:
      self.navigationController?.pushViewController(WalWalFeedViewController(), animated: true)
    case .WalWalButton:
      self.navigationController?.pushViewController(WalWalButtonDemoViewController(), animated: true)
    case .WalWalProfile:
      self.navigationController?.pushViewController(WalWalProfileDemoViewController(), animated: true)
    case .WalWalToast:
      self.navigationController?.pushViewController(WalWalToastViewController(), animated: true)
    default: return
    }
  }
}


