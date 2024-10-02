//
//  ReportTypeViewImp.swift
//  FeedPresenterImp
//
//  Created by Jiyeon on 10/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import FeedPresenter
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxCocoa

public final class ReportTypeViewControllerImp<R: ReportTypeReactor>:
  UIViewController,
    ReportTypeViewController {
  
  private typealias Fonts = ResourceKitFontFamily
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Images = ResourceKitAsset.Images
  
  // MARK: - UI
  
  private let rootContainer = UIView().then {
    $0.backgroundColor = Colors.white.color
    $0.isUserInteractionEnabled = true
  }
  
  private let navTitle = CustomLabel(text: "신고", font: Fonts.KR.H5.B).then {
    $0.textColor = Colors.black.color
    $0.textAlignment = .center
  }
  
  
  private let headerView = UIView()
  
  private let titleLabel = CustomLabel(
    text: "이 게시물을 신고하려는 이유가 무엇인가요?",
    font: Fonts.KR.H6.B
  ).then {
    $0.textColor = Colors.black.color
    $0.textAlignment = .center
  }
  
  private let descriptionLabel = CustomLabel(
    text: "여러분의 신고 내용을 신중히 검토한 후,\n빠른 시일 내 적절한 조치를 취하겠습니다.",
    font: Fonts.KR.B2
  ).then {
    $0.textColor = Colors.gray600.color
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  
  private let tableView = UITableView(frame: .zero, style: .plain).then {
    $0.register(ReportTypeCell.self)
    $0.rowHeight = 57.adjustedHeight
    $0.separatorStyle = .none
    $0.showsVerticalScrollIndicator = false
    $0.isScrollEnabled = false
  }
  
  // MARK: - Properties
  
  public var reportTypeReactor: R
  public var disposeBag = DisposeBag()
  private let reportItems = ReportType.allCases
  
  // MARK: - Initalize
  
  public init(reactor: R) {
    self.reportTypeReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.reactor = reportTypeReactor
    configureAttribute()
    configureLayout()
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
  }
  
  public func configureAttribute() {
    view.backgroundColor = .clear
    view.addSubview(rootContainer)
    
    rootContainer.layer.cornerRadius = 30
    rootContainer.layer.maskedCorners = CACornerMask(
      arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner
    )
  }
  
  public func configureLayout() {
    
    rootContainer.flex
      .paddingHorizontal(20.adjustedWidth)
      .define {
        $0.addItem(navTitle)
          .marginTop(24.adjustedHeight)
        $0.addItem(headerView)
        $0.addItem(tableView)
          .marginBottom(43.adjustedHeight)
          .marginTop(11.adjustedHeight)
      }
    
    headerView.flex
      .paddingTop(30.adjustedHeight)
      .paddingBottom(30.adjustedHeight)
      .define {
        $0.addItem(titleLabel)
          .width(100%)
        $0.addItem(descriptionLabel)
          .width(100%)
          .marginTop(8.adjusted)
      }
  }
}

extension ReportTypeViewControllerImp: View {
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  public func bindAction(reactor: R) {
    tableView.rx.modelSelected(ReportType.self)
      .map { Reactor.Action.tapReportItem(item: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    Observable.just(reportItems)
      .bind(to: tableView.rx.items(ReportTypeCell.self)) { index, data, cell in
        cell.titleLabel.text = data.title
        cell.isSeparatorHidden = index == self.reportItems.count-1
        cell.selectionStyle = .none
      }
      .disposed(by: disposeBag)
  }
}
