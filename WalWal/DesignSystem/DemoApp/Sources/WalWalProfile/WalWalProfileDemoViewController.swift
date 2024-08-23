//
//  WalWalProfileDemoViewController.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import DesignSystem

import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

final class WalWalProfileDemoViewController: UIViewController {
  
  private let rootContainer = UIView()
  private let profileSelectView = WalWalProfile(type: .dog)
  private let profileSelectView2 = WalWalProfile(
    type: .cat,
    defaultImage: "GREEN_CAT"
    
  )
  private let profileSelectView3 = WalWalProfile(
    type: .cat,
    userImage: ResourceKitAsset.Assets.onboarding3.image
  )
  private let profileInfoLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.textColor = .black
    $0.font = ResourceKitFontFamily.KR.H5.M
  }
  private let completeButton = WalWalButton(type: .active, title: "완료")
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureLayout()
    bind()
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin
      .all(view.pin.safeArea)
    rootContainer.flex
      .layout()
  }
  
  private func configureLayout() {
    view.addSubview(rootContainer)
    
    rootContainer.flex
      .define {
        $0.addItem()
          .justifyContent(.center)
          .grow(1)
          .define {
            $0.addItem(profileSelectView)
              .width(100%)
            $0.addItem(profileSelectView2)
              .width(100%)
            $0.addItem(profileSelectView3)
              .width(100%)
          }
        
        $0.addItem(completeButton)
          .marginHorizontal(20)
          .marginBottom(30)
          
      }
  }
  
  private func bind() {
//    사용할 뷰컨에서 구현
//    profileSelectView.showPHPicker
//      .bind(with: self) { owner, _ in
//        PHPickerManager.shared.presentPicker(vc: owner)
//      }
//      .disposed(by: disposeBag)
    
//    PHPickerManager.shared.selectedPhoto
//      .asDriver(onErrorJustReturn: nil)
//      .compactMap { $0 }
//      .drive(with: self) { owner, image in
//        owner.profileSelectView.selectedImageData.accept(image)
//      }
//      .disposed(by: disposeBag)
    
    profileSelectView.curProfileItems
      .bind(with: self) { owner, info in
        if info.profileType == .selectImage {
          if info.selectImage == nil {
            owner.completeButton.rx.buttonType.onNext(.disabled)
          } else {
            owner.completeButton.rx.buttonType.onNext(.active)
          }
        }
      }
      .disposed(by: disposeBag)
    
    completeButton.rx.tapped
      .withLatestFrom(profileSelectView.curProfileItems) {
        return $1
      }
      .bind(with: self) { owner, info in
        owner.profileInfoLabel.text = """
        profile Type: \(info.profileType)
        selectImage: \(String(describing: info.selectImage ?? nil))
        defaultImage: \(String(describing: info.defaultImage?.rawValue ?? nil))
        """
        owner.view.layoutIfNeeded()
      }
      .disposed(by: disposeBag)
    
  }
}
