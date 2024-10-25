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
    Observable.just(AlertEventType.deleteMissionRecord)
      .bind(to: WalWalAlert.shared.rx.showAlert)
      .disposed(by: disposeBag)
  }
  
  private func bind() {
    WalWalAlert.shared.rx.okEvent
      .subscribe(onNext: { result in
        switch result {
        default: print("이벤트 타입: \(result.self)")
        }
      })
      .disposed(by: disposeBag)
  }
}
