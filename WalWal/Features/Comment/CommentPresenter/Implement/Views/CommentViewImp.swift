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
    $0.backgroundColor = Colors.black70.color
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
    $0.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
  }
  
  private let inputBox = CustomInputBox(
    placeHolderText: "댓글을 입력하세요!",
    placeHolderFont: FontKR.B1,
    placeHolderColor: AssetColor.gray500.color,
    inputTextFont: FontKR.B1,
    inputTextColor: AssetColor.black.color,
    inputTintColor: AssetColor.blue.color,
    buttonActiveColor: AssetColor.walwalOrange.color
  )
  
  // MARK: - Properties
  
  private var dataSource: UITableViewDiffableDataSource<Section, FlattenCommentModel>!
  
  private var parentIdRelay = BehaviorRelay<Int?>(value: nil)
  
  private let checkScrollComment = BehaviorRelay<Bool>(value: false)
  
  private let resetFocusing = PublishRelay<Void>()
  
  private let completedLoading = PublishRelay<Void>()
  
  private var focusCommentId: Int? = nil
  
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
      .left()
      .right()
      .bottom()
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
      .height(548.adjustedHeight)
      .define { flex in
        flex.addItem(headerContainerView)
        flex.addItem(tableViewContainerView)
        flex.addItem(inputBox)
          .height(58.adjustedHeight)
      }
    
    headerContainerView.flex
      .height(58.adjustedHeight)
      .width(100%)
      .alignItems(.center)
      .define { flex in
        flex.addItem(commentLabel)
          .marginTop(24.adjustedHeight)
      }
    
    tableViewContainerView.flex
      .grow(1)
      .define { flex in
        flex.addItem(tableView)
          .position(.absolute)
          .top(0)
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
    self.dimView.alpha = 0
    UIView.animate(withDuration: 0.3, animations: {
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
      self.dimView.alpha = 0
      rootContainerView.pin
        .bottom(-position)
    } else {
      animateSheetUp()
    }
  }
  
  /// 키보드 올라갔을 때 레이아웃 재설정
  private func keyboardShowLayout(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    
    let keyboardHeight = keyboardFrame.height
    let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.3
    let animationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt) ?? UIView.AnimationOptions.curveEaseInOut.rawValue
    
    UIView.animate(withDuration: animationDuration,
                   delay: 0,
                   options: UIView.AnimationOptions(rawValue: animationCurve),
                   animations: {
      self.rootContainerView.flex
            .height(456.adjustedHeight + self.view.pin.safeArea.bottom)
            .bottom(keyboardHeight - self.view.pin.safeArea.bottom)
      self.rootContainerView.flex.layout()
    })
  }
  
  /// 키보드 내려갔을 때 레이아웃 재설정
  private func keyboardHideLayout(notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.3
    let animationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt) ?? UIView.AnimationOptions.curveEaseInOut.rawValue
    
    UIView.animate(withDuration: animationDuration,
                   delay: 0,
                   options: UIView.AnimationOptions(rawValue: animationCurve),
                   animations: {
      self.rootContainerView.flex
        .height(548.adjustedHeight)
        .bottom(0)
      self.rootContainerView.flex.layout()
    })
  }
  
  // MARK: - TableView
  
  private func setupTableView() {
    tableView.delegate = self
  }
  
  private func setupDataSource() {
    dataSource = UITableViewDiffableDataSource<Section, FlattenCommentModel>(tableView: tableView) { [weak self] (tableView, indexPath, comment) -> UITableViewCell? in
      guard let owner = self else { return nil }
      if comment.parentID == nil {
        let cell = tableView.dequeue(CommentCell.self, for: indexPath)
        cell.configure(with: comment, writerNickname: owner.commentReactor.initialState.writerNickname, writerId: comment.writerID)
        
        cell.parentIdGetted
          .bind(to: owner.parentIdRelay)
          .disposed(by: cell.disposeBag)
        
        cell.replyButton.rx.tapped
          .subscribe(onNext: { _ in
            owner.inputBox.rx.startEditing.onNext(())
          })
          .disposed(by: cell.disposeBag)
        
        return cell
      } else {
        let cell = tableView.dequeue(ReplyCommentCell.self, for: indexPath)
        cell.configure(with: comment, writerNickname: owner.commentReactor.initialState.writerNickname, writerId: comment.writerID)
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
  
  /// commentId값으로 스크롤 이동
  private func scrollFocusComment(id: Int) {
    
    if let index = reactor?.currentState.comments.firstIndex(where: {$0.commentID == id}) {
      let indexPath = IndexPath(item: index, section: 0)
      tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
      
      /// 포커스 주려면 스크롤 완료 후 보여줘야 함
      DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
        self.configFocusCell(index: indexPath)
      }
    }
  }
  
  private func configFocusCell(index: IndexPath) {
    if let cell = tableView.cellForRow(at: index) as? CommentCell {
      cell.configFocusing()
    } else if let cell = tableView.cellForRow(at: index) as? ReplyCommentCell {
      cell.configFocusing()
    }
    resetFocusing.accept(())
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
        self.completedLoading.accept(())
      })
      .disposed(by: disposeBag)
      
    reactor.state
      .map { $0.sheetPosition }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] position in
        guard let self = self else { return }
        self.updateSheetPosition(position)
      })
      .disposed(by: disposeBag)
    
    
    reactor.state
      .map { $0.isNeedFocusing }
      .bind(to: checkScrollComment)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.focusCommentId }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: nil)
      .compactMap { $0 }
      .drive(with: self) { owner, commentId in
        owner.focusCommentId = commentId
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
    
    dimView.rx.tapped
    .subscribe(with: self, onNext: { owner, _ in
      owner.inputBox.rx.textEndEditing.onNext(())
      owner.animateSheetDown {
        reactor.action.onNext(.tapDimView(commentCount: reactor.currentState.totalComment))
      }
    })
    .disposed(by: disposeBag)
    
    // 댓글 작성 시 액션
    inputBox.rx.postButtonTap
      .withLatestFrom(inputBox.rx.text)
      .map { Reactor.Action.postComment(content: $0) }
      .do(onNext: { [weak self] _ in
        self?.inputBox.rx.textEndEditing.onNext(())
        self?.inputBox.clearText()
      })
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 답글 달기 눌렀을 때
    parentIdRelay.asObservable()
      .map { Reactor.Action.setReplyMode(isReply: true, parentId: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    resetFocusing
      .map { Reactor.Action.resetFocusing }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    completedLoading
      .withLatestFrom(checkScrollComment)
      .filter { $0 }
      .map { _ in self.focusCommentId }
      .asDriver(onErrorJustReturn: nil)
      .compactMap { $0 }
      .drive(with: self) { owner, commentId in
        owner.scrollFocusComment(id: commentId)
      }
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .bind(with: self) { owner, notification in
        owner.keyboardShowLayout(notification: notification)
      }
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .bind(with: self) { owner, notification in
        owner.keyboardHideLayout(notification: notification)
      }
      .disposed(by: disposeBag)
    
    tableViewContainerView.rx.tapped
      .bind(to: inputBox.rx.textEndEditing)
      .disposed(by: disposeBag)
    
    inputBox.rx.tapped
      .subscribe(with: self, onNext: { owner, _ in
        guard let dataSource = owner.dataSource else { return }
        let lastSectionIndex = dataSource.numberOfSections(in: owner.tableView) - 1
        let lastRowIndex = dataSource.tableView(owner.tableView, numberOfRowsInSection: lastSectionIndex) - 1
        
        if lastSectionIndex >= 0 && lastRowIndex >= 0 {
          let lastIndexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
          self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
      })
      .disposed(by: disposeBag)
  }
  
}

// MARK: - Section Enum
enum Section {
  case main
}
