//
//  WalWalAlertViewController.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import RxSwift

public final class WalWalAlertViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    bind()
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    WalWalAlert.shared.show(
      title: "회원 탈퇴",
      bodyMessage: "회원 탈퇴 시, 계정은 삭제되며 기록된 내용은 복구되지 않습니다.",
      cancelTitle: "계속 이용하기",
      okTitle: "회원 탈퇴"
    )
  }
  
  private func bind() {
    WalWalAlert.shared.resultRelay
      .bind(with: self) { owner, result in
        switch result {
        case .cancel:
          print("cancel")
          WalWalAlert.shared.closeAlert.accept(())
        case .ok:
          print("ok")
        }
      }
      .disposed(by: disposeBag)
  }
}
