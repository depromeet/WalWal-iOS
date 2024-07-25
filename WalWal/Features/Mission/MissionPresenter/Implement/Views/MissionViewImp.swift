//
//  MissionViewControllerImp.swift
//
//  Mission
//
//  Created by 이지희
//


import UIKit
import MissionPresenter

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class MissionViewControllerImp<R: MissionReactor>: UIViewController, MissionViewController {
  public var disposeBag = DisposeBag()
  public var missionReactor: R
  
  // MARK: - UI
  
  
  private let rootContainer = UIView()
  private let missionTimerView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.3)
    $0.layer.cornerRadius = 20
  }
  private let missionTimerImageView = UIImageView().then {
    $0.image = UIImage(systemName: "timer")?.withTintColor(.white, renderingMode: .alwaysOriginal)
  }
  private let missionTimerLabel = UILabel().then {
    $0.text = "오늘의 미션"
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
  }
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 28, weight: .bold)
    $0.textColor = .black
    $0.text = "반려동물과 함께\n산책한 사진을 찍어요"
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  private let missionImageView = UIImageView().then {
    $0.image = UIImage(systemName: "heart.fill")
  }
  private let dateLabel = UILabel().then {
    $0.text = "123일째"
  }
  private let missionStartButton = UIButton().then {
    $0.backgroundColor = .black
    $0.setImage(UIImage(systemName: "flag.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal),
                for: .normal)
    $0.setTitle("미션하러 가기", for: .normal)
  }
  
  // MARK: - Initialize
  
  public init(reactor: R) {
    self.missionReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setAttribute()
    setLayout()
    self.reactor = missionReactor
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
  }
  
  public func setAttribute() {
    view.backgroundColor = .lightGray
    view.addSubview(rootContainer)
    
    [missionTimerImageView, missionTimerLabel].forEach {
      missionTimerView.addSubview($0)
    }
  }
  
  public func setLayout() {
    rootContainer.flex.justifyContent(.center).define {
      $0.addItem(missionTimerView).marginTop(20).height(40).width(120).alignSelf(.center)
      $0.addItem(titleLabel).marginTop(20)
      $0.addItem(missionImageView).marginTop(20).marginHorizontal(0).height(341)
      $0.addItem(dateLabel).marginTop(20).alignSelf(.center)
      $0.addItem(missionStartButton).marginTop(20).marginHorizontal(20).height(50)
    }
    
    missionTimerView.flex.direction(.row).justifyContent(.center).alignItems(.center).define {
      $0.addItem(missionTimerImageView)
      $0.addItem(missionTimerLabel).marginLeft(3.5)
    }
  }
  
  public func bindEvent() {
    
  }
}

extension MissionViewControllerImp: View {
  
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
}
