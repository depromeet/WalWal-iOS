import UIKit
import DesignSystem

import FlexLayout
import PinLayout
import RxSwift
import RxCocoa
import RxGesture

final class WalWalCalenderDemoViewController: UIViewController {
  
  // MARK: - UI
  
  private let rootView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let headerContainerView = UIView().then {
    $0.backgroundColor = .lightGray
    $0.layer.masksToBounds = true
    $0.layer.cornerRadius = 16
  }
  
  private let calenderViewHeaderView = WalWalCalendarHeaderView()
  
  private let calendarWeekDayView = WalWalCalendarWeekdayView()
  
  private let calendarMonthView = WalWalCalendarMonthView()
  
  // MARK: - Properties
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  public init() {
      super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.rootView)
    setLayouts()
    bind()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.rootView.pin.all(view.pin.safeArea)
    self.rootView.flex.layout(mode: .fitContainer)
  }
  
  // MARK: - Methods
  
  private func setLayouts() {
    self.rootView.flex.padding(0, 20).direction(.column).alignItems(.center).define { flex in
      flex.addItem(headerContainerView).width(200).height(44).justifyContent(.center).alignItems(.center).marginTop(28).define { flex in
        flex.addItem(calenderViewHeaderView).width(100%).height(100%)
      }
      flex.addItem(calendarWeekDayView).width(100%).height(30).marginTop(30)
      flex.addItem(calendarMonthView).width(100%).height(100%).marginTop(10)
    }
  }
  
  private func bind() {
    calenderViewHeaderView.rx.monthChanged
      .bind(to: calendarMonthView.monthChangedSubject)
      .disposed(by: disposeBag)
  }
}
