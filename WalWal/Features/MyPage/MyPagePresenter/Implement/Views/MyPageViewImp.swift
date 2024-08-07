//
//  MyPageViewControllerImp.swift
//
//  MyPage
//
//  Created by 조용인
//


import UIKit
import MyPagePresenter
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class MyPageViewControllerImp<R: MyPageReactor>: UIViewController, MyPageViewController {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let containerView = UIView().then {
    $0.backgroundColor = Colors.gray100.color
  }
  
  private let navigationBar = WalWalNavigationBar(
    leftItems: [],
    title: "내 정보",
    rightItems: [.setting]
  ).then { $0.backgroundColor = Colors.white.color }
  
  private let seperator = UIView().then {
    $0.backgroundColor = Colors.gray150.color
  }
  
  private let calendar = WalWalCalendar(initialModels: SampleDataGenerator.createRandomSampleCalendarModels())
  
  private let profileCardView = WalWalProfileCardView(
    profileImage: ResourceKitAsset.Sample.calendarCellSample.image,
    name: "조용인",
    subDescription: "안녕하세요 반가워요 👍🏻",
    chipStyle: .tonal,
    chipTitle: "눌러봐",
    selectedChipStyle: .filled,
    selectedChipTitle: "🔥"
  )
  
  public var disposeBag = DisposeBag()
  public var mypageReactor: R
  
  public init(
    reactor: R
  ) {
    self.mypageReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.reactor = mypageReactor
    setAttribute()
    setLayout()
    bind()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    containerView
      .pin
      .all(view.pin.safeArea)
    containerView
      .flex
      .layout()
  }
  
  // MARK: - Methods
  
  
  public func setAttribute() {
    view.backgroundColor = Colors.white.color
  }
  
  public func setLayout() {
    view.addSubview(containerView)
    
    containerView.flex
      .direction(.column)
      .define { flex in
        flex.addItem(navigationBar)
        flex.addItem(seperator)
          .height(1)
          .width(100%)
        flex.addItem(calendar)
          .grow(1)
        flex.addItem(profileCardView)
      }
  }
  
  func bind() {
  }
}

extension MyPageViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    calendar.selectedDayData
      .map {
        Reactor.Action.didSelectCalendarItem($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    
  }
}

private enum SampleDataGenerator {
  static func createRandomSampleCalendarModels(count: Int = 50) -> [WalWalCalendarModel] {
    let sampleImageData = ResourceKitAsset.Sample.calendarCellSample.image.pngData() ?? Data()
    let calendar = Calendar.current
    let today = Date()
    let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: today)!
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let sampleModels = (1...count).map { _ -> WalWalCalendarModel in
      let randomDate = Date(timeIntervalSince1970: .random(in: oneYearAgo.timeIntervalSince1970...today.timeIntervalSince1970))
      let dateString = dateFormatter.string(from: randomDate)
      let id = "\(dateString)의 이미지 입니당 🐶"
      return WalWalCalendarModel(imageId: id, date: dateString, imageData: sampleImageData)
    }
    
    return sampleModels.sorted { $0.date < $1.date }
  }
}
