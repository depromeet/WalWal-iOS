//
//  BaseCoordinatorInterface.swift
//
//  Base
//
//  Created by 조용인
//

import UIKit

import RxSwift
import RxCocoa

public protocol CoordinatorFlow { }

public protocol ParentAction { }

/// 자식이 부모에게 처리하기를 요청하는 이벤트입니다.
public enum CoordinatorEvent<Action: ParentAction> {
  case finished
  case requireParentAction(Action)
}

public protocol BaseCoordinator: AnyObject{
  associatedtype Action: ParentAction
  associatedtype Flow: CoordinatorFlow
  
  // MARK: - Properties
  
  var disposeBag: DisposeBag { get }
  
  /// Coordinator Flow를 전달하는 PublishRelay입니다. 해당 변수에 원하는 Flow를 주입하면, 해당 Flow에 맞게 화면로직이 동작합니다.
  var destination: PublishRelay<Flow> { get }
  
  /// 자식의 요구에 따라 부모가 어떠한 동작을 할 지 관리하는 PublishSubject입니다.
  var requireFromChild: PublishSubject<CoordinatorEvent<Action>> { get }
  
  /// Navigation Stack을 관리하는 NavigationController. 새롭게 생성되어야하는 Navigation Stack이 아닌 이상, 부모에서 자식으로 계속 주입합니다.
  var navigationController: UINavigationController { get }
  
  /// 부모 Coordinator를 관리하는 변수
  var parentCoordinator: (any BaseCoordinator)? { get set }
  
  /// 자식 Coordinator를 관리하는 변수
  var childCoordinator: (any BaseCoordinator)? { get set }
  
  /// 자신Coordinator의 BaseViewController를 정의합니다. (navigationController의 Root가 아닙니다.)
  var baseViewController: UIViewController? { get set }
  
  // MARK: - Methods
  
  /// Coordinator의 CoordinatorFlow에 따라서, 어떤 화면전환 로직을 구현할 지 처리합니다.
  func bindState()
  
  /// Coordinator의 BaseViewController를 NavigationController에 Push합니다.
  func start()
  
  /// 자식이 부모에게 특정 동작을 요청할 때 사용하면 됩니다.
  func handleChildEvent<T: ParentAction>(_ event: T)
}

// MARK: - 기본 구현 함수들

public extension BaseCoordinator{
  
  /// 나의 baseViewController까지 pop 시켜줍니다.
  /// 또한, finish가 호출되면 나의 childCoordinator를 nil로 만들어주고, 부모 Coordinator에게 자신이 종료되어야 한다는 사실을 알려줍니다.
  func requirefinish() {
    if let baseVC = baseViewController, navigationController.viewControllers.contains(baseVC) {
      popToRootViewController(animated: false)
    }
    childCoordinator = nil
    requireFromChild.onNext(.finished)
  }
  
  /// 나의 baseViewController까지 pop 시켜줍니다.
  /// 또한, finish가 호출되면 나의 childCoordinator를 nil로 만들어주고, 부모 Coordinator에게 자신이 종료됨과 동시에 부모에게 특정 동작을 요청할 때 사용하면 됩니다.
  func requireParentAction(_ action: Action) {
    popToRootViewController(animated: false)
    childCoordinator = nil
    requireFromChild.onNext(.requireParentAction(action))
  }
  
  /// requireFromChild에 새로운 값이 전달 될 때마다, 해당 값에 해당하는 Action을 parent에게 전달해줍니다.
  func bindChildToParentAction() {
    requireFromChild
      .subscribe(with: self, onNext: { owner, event in
        guard let parentCoordinator = owner.parentCoordinator else { return }
        switch event {
        case .finished:
          parentCoordinator.handleJustFinish()
        case .requireParentAction(let action):
          parentCoordinator.handleChildEvent(action)
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식으로 부터 단순 .finished 이벤트가 전달 될 때, 자식 Coordinator를 nil로 만들어주고 자식의 baseViewController를 pop해줍니다.
  func handleJustFinish() {
    popViewController(animated: true)
    childCoordinator = nil
  }
}

// MARK: - CoordinatorType의 화면 전환 관련 함수들

public extension BaseCoordinator {
  
  /// 현재 Navigation Stack에 새로운 ViewController를 Push 함
  func pushViewController(viewController vc: UIViewController, animated: Bool, swipe: Bool = true){
    self.navigationController.setNavigationBarHidden(true, animated: false)
    if swipe {
      self.navigationController.interactivePopGestureRecognizer?.isEnabled = swipe
      self.navigationController.interactivePopGestureRecognizer?.delegate = nil
    }
    self.navigationController.pushViewController(vc, animated: animated)
  }
  
  /// 현재 Navigation Stack에서 최상단의 ViewController를 Pop 함
  func popViewController(animated: Bool) {
    self.navigationController.popViewController(animated: animated)
  }
  
  /// 현재 최상단의 ViewController에서 새로운 ViewController를 Present 해 줌
  func presentViewController(viewController vc: UIViewController, style: UIModalPresentationStyle, animated: Bool = true){
    vc.modalPresentationStyle = style
    self.navigationController.present(vc, animated: animated)
  }
  
  /// 현재 최상단의 ViewController에서 Present되어있는 ViewController를 Dismiss 해 줌
  func dismissViewController(animated: Bool = true,completion: (() -> Void)?) {
    navigationController.dismiss(animated: animated, completion: completion)
  }
  
  /// 현재 Coordinator의 BaseViewController로 정의되어있는 ViewController로 돌아옴. 이 때, 주의할 점은 Navigation의 Root가 아닌, Coordinator에 정의되어있는 Base로 돌아옴.
  func popToRootViewController(animated: Bool) {
    if let rootViewController = self.baseViewController {
      navigationController.popToViewController(rootViewController, animated: animated)
    } else {
      navigationController.popToRootViewController(animated: animated)
    }
  }
  
  /// 현재 NavigationController에 내가 찾고자하는 ViewController가 존재하는지(Push 되어있는 지)를 확인함.
  func isHasViewController(ofKind kind: AnyClass) -> Bool {
    return self.navigationController.viewControllers.contains { $0.isKind(of: kind) }
  }
  
  /// 현재 NavigationController에서 내가 찾고자하는 ViewController를 return해줌.
  func findViewController(ofKind kind: AnyClass) -> UIViewController? {
    return self.navigationController.viewControllers.first { $0.isKind(of: kind) }
  }
  
  /// 현재 NavigationController에 존재하는 ViewController중, 내가 이동하고자 하는 ViewController까지 이동.
  /// (개념적으로는, 해당 ViewController까지 Pop한다고 생각하면 됨. )
  func moveToViewController(ofKind kind: AnyClass) {
    guard let destination = findViewController(ofKind: kind) else { return }
    navigationController.popToViewController(destination, animated: true)
  }
}
