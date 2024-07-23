import UIKit
import DesignSystem

import FlexLayout
import PinLayout
import RxSwift
import RxCocoa
import RxGesture

final class WalWalCalenderDemoViewController: UIViewController {
  
  // MARK: - UI
  
  private let containerView = UIView().then {
    $0.backgroundColor = .darkGray
    $0.layer.masksToBounds = true
    $0.layer.cornerRadius = 16
  }
  
  private let calenderView = WalWalCalendarHeaderView()
  
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
    self.view.addSubview(self.containerView)
    setLayouts()
    bind()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.containerView.pin.top(view.pin.safeArea.top).hCenter().width(200).height(44)
    self.containerView.flex.layout(mode: .fitContainer)
  }
  
  // MARK: - Methods
  
  private func setLayouts() {
    self.containerView.flex.justifyContent(.center).alignItems(.center).define { flex in
      flex.addItem(calenderView).width(100%).height(100%)
    }
  }
  
  private func bind() { }
}
