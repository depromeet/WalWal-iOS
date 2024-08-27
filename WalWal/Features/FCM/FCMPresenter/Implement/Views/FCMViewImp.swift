//
//  FCMViewControllerImp.swift
//
//  FCM
//
//  Created by 이지희
//


import UIKit
import FCMPresenter
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class FCMViewControllerImp<R: FCMReactor>: UIViewController, FCMViewController {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  public var disposeBag = DisposeBag()
  public var fcmReactor: R
  
  // MARK: - UI
  
  private let rootContainerView = UIView()
  private let titleLabel = UILabel().then {
    $0.text = "앗.."
    $0.font = Fonts.LotteriaChab.Buster_Cute
    $0.textColor = Colors.black.color
  }
  private let subTitelLabel = UILabel().then {
    $0.text = "아직 알림이 없어요!"
    $0.font = Fonts.KR.H5.B
    $0.textColor = Colors.black.color
  }
  private let guideLabel = UILabel().then {
    $0.text = "조금만 기다리면 알림이 올 거예요."
    $0.numberOfLines = 2
    $0.textAlignment = .center
    $0.font = Fonts.KR.H7.M
    $0.textColor = Colors.black.color
  }
  private let actionButton = WalWalButton(type: .dark, title: "")
  
  
  public init(
      reactor: R
  ) {
    self.fcmReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupAttribute()
    setupLayout()
    self.reactor = fcmReactor
  }
  
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainerView.pin
      .all(view.pin.safeArea)
    rootContainerView.flex
      .layout()
  }
  
    
  
  public func setupAttribute() {
    view.backgroundColor = Colors.gray150.color
    view.addSubview(rootContainerView)
  }
  
  public func setupLayout() {
    rootContainerView.flex
      .direction(.column)
      .alignItems(.center)
      .justifyContent(.center)
      .define {
        $0.addItem(titleLabel)
        $0.addItem(subTitelLabel)
          .marginTop(20)
        $0.addItem(guideLabel)
          .marginTop(4)
      }
  }
}

extension FCMViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    
  }
}
