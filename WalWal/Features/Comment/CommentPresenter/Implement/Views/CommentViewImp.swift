//
//  CommentViewControllerImp.swift
//
//  Comment
//
//  Created by 조용인
//

import UIKit
import CommentPresenter
import CommentDomain
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class CommentViewControllerImp<R: CommentReactor>: UIViewController, CommentViewController, UITableViewDelegate {
  
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias Colors = ResourceKitAsset.Colors
  private typealias AssetColor = ResourceKitAsset.Colors
  
  private let panGesture = UIPanGestureRecognizer()
  public var disposeBag = DisposeBag()
  public var commentReactor: R
  
  private let dimView = UIView().then {
    $0.backgroundColor = Colors.black30.color
  }
  
  private let rootContainerView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let headerContainerView = UIView()
  private let tableViewContainerView = UIView()
  
  private let commentLabel = CustomLabel(text: "댓글", font: FontKR.H5.B ).then {
    $0.textColor = AssetColor.black.color
  }
  
  private let tableView = UITableView().then {
    $0.backgroundColor = .white
    $0.register(CommentCell.self)
    $0.register(ReplyCommentCell.self)
    $0.separatorStyle = .none
    $0.showsVerticalScrollIndicator = false
    $0.estimatedRowHeight = 60
    $0.rowHeight = UITableView.automaticDimension
  }
  
  private let inputBox = CustomInputBox(
    placeHolderText: "댓글을 입력하세요!",
    placeHolderFont: FontKR.H7.M,
    placeHolderColor: AssetColor.gray500.color,
    inputTextFont: FontKR.H7.M,
    inputTextColor: AssetColor.black.color,
    inputTintColor: AssetColor.blue.color,
    buttonActiveColor: AssetColor.walwalOrange.color
  )
  
  private var dataSource: UITableViewDiffableDataSource<Section, FlattenCommentModel>!
  private var parentIdRelay = BehaviorRelay<Int>(value: 0)
  
  public init(reactor: R) {
    self.commentReactor = reactor
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
    self.reactor = commentReactor
  }
  
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
    rootContainerView.pin
      .bottom(-rootContainerView.frame.height)
    
    let _ = view.pin.keyboardArea.height
    
    dimView.pin
      .all()
    dimView.flex
      .layout()
    
    rootContainerView.pin
      .bottom(-rootContainerView.frame.height)
      .horizontally()
    inputBox.pin
      .height(58)
    rootContainerView.flex
      .layout()
  }
  
  // MARK: - UI Setup
  
  public func setAttribute() {
    view.backgroundColor = .clear
    view.addSubview(dimView)
    view.addSubview(rootContainerView)
    
    rootContainerView.layer.cornerRadius = 30
    rootContainerView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    setupTableView()
    setupDataSource()
  }
  
  public func setLayout() {
    
    rootContainerView.flex
      .height(580.adjustedHeight)
      .define { flex in
        flex.addItem(headerContainerView)
        flex.addItem(tableViewContainerView)
        flex.addItem(inputBox)
          .height(58)
      }
    
    headerContainerView.flex
      .height(58)
      .width(100%)
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
        flex.addItem(commentLabel)
      }
    
    tableViewContainerView.flex
      .grow(1)
      .define { flex in
        flex.addItem(tableView)
          .position(.absolute)
          .top(20)
          .width(100%)
          .bottom(0)
      }
  }
  
  // MARK: - Animation
  
  private func animateSheetUp() {
    UIView.animate(withDuration: 0.3) {
      self.dimView.alpha = 1
      self.rootContainerView.pin
        .bottom(0)
      self.inputBox.flex
        .marginBottom(self.view.pin.safeArea.bottom)
      self.rootContainerView.flex
        .layout()
    }
  }
  
  private func animateSheetDown(completion: (() -> Void)? = nil) {
    UIView.animate(withDuration: 0.3, animations: {
      self.dimView.alpha = 0
      self.rootContainerView.pin
        .bottom(-self.rootContainerView.frame.height)
      self.rootContainerView.flex
        .layout()
    }, completion: { _ in
      completion?()
    })
  }
  
  private func updateSheetPosition(_ position: CGFloat) {
    if position > 0 {
      rootContainerView.pin
        .bottom(-position)
    } else {
      animateSheetUp()
    }
  }
  
  /// 키보드 올라갔을 때 레이아웃 재설정
  private func keyboardShowLayout() {
    let keyboardTop = view.pin.keyboardArea.height
    
    inputBox.flex
      .marginBottom(keyboardTop)
      .height(58)
    rootContainerView.flex
      .layout()
  }
  
  /// 키보드 내려갔을 때 레이아웃 재설정
  private func keyboardHideLayout() {
    inputBox.flex
      .marginBottom(view.pin.safeArea.bottom)
    rootContainerView.flex
      .layout()
  }
  
  private func setupTableView() {
    tableView.delegate = self
  }
  
  private func setupDataSource() {
    dataSource = UITableViewDiffableDataSource<Section, FlattenCommentModel>(tableView: tableView) { [weak self] (tableView, indexPath, comment) -> UITableViewCell? in
      guard let owner = self else { return nil }
      if comment.parentID == nil {
        let cell = tableView.dequeue(CommentCell.self, for: indexPath)
        cell.configure(with: comment)
        
        cell.parentIdGetted
          .bind(to: owner.parentIdRelay)
          .disposed(by: cell.disposeBag)
        
        return cell
      } else {
        let cell = tableView.dequeue(ReplyCommentCell.self, for: indexPath)
        cell.configure(with: comment)
        return cell
      }
    }
  }
  
  private func updateSnapshot(with comments: [FlattenCommentModel]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, FlattenCommentModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(comments, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

extension CommentViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  // 상태를 바인딩하는 함수
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.comments }
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] comments in
        guard let self = self else { return }
        self.updateSnapshot(with: comments)
      })
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.sheetPosition }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] position in
        guard let self = self else { return }
        self.updateSheetPosition(position)
      })
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.isSheetDismissed }
      .filter { $0 }
      .subscribe(with: self) { owner, isSheetDismissed in
        owner.dismiss(animated: false)
      }
      .disposed(by: disposeBag)
  }
  
  public func bindAction(reactor: R) {
    headerContainerView.rx
      .panGesture()
      .asObservable()
      .subscribe(with: self, onNext: { owner, gesture in
        let translation = gesture.translation(in: owner.rootContainerView)
        let velocity = gesture.velocity(in: owner.rootContainerView)
        
        switch gesture.state {
        case .changed:
          reactor.action.onNext(.didPan(translation: translation, velocity: velocity))
        case .ended:
          reactor.action.onNext(.didEndPan(velocity: velocity))
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
      return !owner.rootContainerView.frame.contains(location)
    }
    .subscribe(with: self, onNext: { owner, _ in
      owner.animateSheetDown {
        reactor.action.onNext(.tapDimView)
      }
    })
    .disposed(by: disposeBag)
    
    // 댓글 작성 시 액션
    inputBox.rx.postButtonTap
      .withLatestFrom(inputBox.rx.text)
      .map { Reactor.Action.postComment(content: $0) }
      .do(onNext: { [weak self] _ in
        self?.inputBox.rx.textEndEditing.onNext(())
      })
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 답글 달기 눌렀을 때
    parentIdRelay.asObservable()
      .map { Reactor.Action.setReplyMode(isReply: true, parentId: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
  }
  
  public func bindEvent() {
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .bind(with: self) { owner, _ in
        owner.keyboardShowLayout()
      }
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .bind(with: self) { owner, _ in
        owner.keyboardHideLayout()
      }
      .disposed(by: disposeBag)
    
    tableViewContainerView.rx.tapped
      .bind(to: inputBox.rx.textEndEditing)
      .disposed(by: disposeBag)
  }
  
}

// MARK: - Section Enum
enum Section {
  case main
}
