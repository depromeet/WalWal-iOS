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
  private let dimView = UIView().then {
    $0.backgroundColor = Colors.black30.color
  }
  
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
  private let sheetDownEvent = PublishRelay<Void>()
  private let endPanGesture = PublishRelay<CGPoint>()
  private let changePanGesture = PublishRelay<(CGPoint, CGPoint)>()
  
  
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
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateSheetUp()
    
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    dimView.pin
      .all()
    dimView.flex
      .layout()
    rootContainer.pin
      .bottom(-rootContainer.frame.height)
    rootContainer.flex
      .layout(mode: .adjustHeight)
    
  }
  
  public func configureAttribute() {
    view.backgroundColor = .clear
    view.addSubview(dimView)
    
    rootContainer.layer.cornerRadius = 30
    rootContainer.layer.maskedCorners = CACornerMask(
      arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner
    )
  }
  
  public func configureLayout() {
    dimView.flex
      .define {
        $0.addItem(rootContainer)
          .position(.absolute)
          .bottom(0)
          .width(100%)
      }
    
    rootContainer.flex
      .height(563.adjustedHeight)
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
  
  
  // MARK: - Animations
  
  private func animateSheetUp() {
    UIView.animate(withDuration: 0.3) {
      self.dimView.alpha = 1
      self.rootContainer.pin.bottom(0)
      self.rootContainer.flex.layout()
    }
  }
  
  private func animateSheetDown(completion: (() -> Void)? = nil) {
    UIView.animate(withDuration: 0.3, animations: {
      self.dimView.alpha = 0
      self.rootContainer.pin.bottom(-self.rootContainer.frame.height)
      self.rootContainer.flex.layout()
    }, completion: { _ in
      completion?()
    })
  }
  
  private func updateSheetPosition(_ position: CGFloat) {
    if position > 0 {
      rootContainer.pin.bottom(-position)
    } else {
      animateSheetUp()
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
    changePanGesture
      .map {
        Reactor.Action.didPan(
          translation: $0.0,
          velocity: $0.1
        )
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    endPanGesture
      .map {
        Reactor.Action.didEndPan(velocity: $0)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    sheetDownEvent
      .map { Reactor.Action.tapDimView }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(ReportType.self)
      .map { Reactor.Action.tapReportItem(item: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.sheetPosition }
      .distinctUntilChanged()
      .subscribe(with: self, onNext: { owner, position in
        owner.updateSheetPosition(position)
      })
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    rootContainer.rx
      .panGesture()
      .asObservable()
      .subscribe(with: self, onNext: { owner, gesture in
        let translation = gesture.translation(in: owner.rootContainer)
        let velocity = gesture.velocity(in: owner.rootContainer)
        
        switch gesture.state {
        case .changed:
          owner.changePanGesture.accept((translation, velocity))
        case .ended:
          owner.endPanGesture.accept(velocity)
        default:
          break
        }
      })
      .disposed(by: disposeBag)
    
    dimView.rx.tapGesture { gestureRecognizer, delegate in
      delegate.simultaneousRecognitionPolicy = .always
      gestureRecognizer.cancelsTouchesInView = false // 터치가 뷰로 전달되도록 허용
    }
    .when(.recognized)
    .withUnretained(self)
    .filter { owner, gesture in
      let location = gesture.location(in: self.view)
      return !owner.rootContainer.frame.contains(location)
    }
    .subscribe(with: self, onNext: { owner, _ in
      owner.animateSheetDown {
        owner.sheetDownEvent.accept(())
      }
    })
    .disposed(by: disposeBag)
    
    Observable.just(reportItems)
      .bind(to: tableView.rx.items(ReportTypeCell.self)) { index, data, cell in
        cell.titleLabel.text = data.title
        cell.isSeparatorHidden = index == self.reportItems.count-1
        cell.selectionStyle = .none
      }
      .disposed(by: disposeBag)
  }
}
