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
  private typealias AssetColor = ResourceKitAsset.Colors
  
  public var disposeBag = DisposeBag()
  public var commentReactor: R
  
  private let rootContainerView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let headerContainerView = UIView()
  private let tableViewContainerView = UIView()
  
  private let commentLabel = CustomLabel(text: "댓글", font: FontKR.H5.B ).then {
    $0.textColor = AssetColor.black.color
  }
  
  private let tableView = UITableView().then {
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
  
  public init(reactor: R) {
    self.commentReactor = reactor
    super.init(nibName: nil, bundle: nil)
    
    commentReactor.action.onNext(.fetchComments(recordId: 503))
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
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let _ = view.pin.keyboardArea.height
    
    rootContainerView.pin
      .vertically(view.pin.safeArea)
      .horizontally()
    inputBox.pin
      .height(58)
    rootContainerView.flex
      .layout()
  }
  
  // MARK: - UI Setup
  public func setAttribute() {
    view.backgroundColor = AssetColor.white.color
    view.addSubview(rootContainerView)
    
    setupTableView()
    setupDataSource()
  }
  
  public func setLayout() {
    
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
    
    rootContainerView.flex
      .define { flex in
        flex.addItem(headerContainerView)
        flex.addItem(tableViewContainerView)
        flex.addItem(inputBox)
          .height(58)
      }
  }
  
  private func keyboardShowLayout() {
    let keyboardTop = view.pin.keyboardArea.height - view.pin.safeArea.bottom
    
    inputBox.flex
      .marginBottom(keyboardTop)
      .height(58)
    rootContainerView.flex
      .layout()
  }
  
  private func keyboardHideLayout() {
    inputBox.flex
      .marginBottom(0)
    rootContainerView.flex
      .layout()
  }
  
  private func setupTableView() {
    tableView.delegate = self
  }
  
  private func setupDataSource() {
    dataSource = UITableViewDiffableDataSource<Section, FlattenCommentModel>(tableView: tableView) { (tableView, indexPath, comment) -> UITableViewCell? in
      if comment.parentID == nil {
        let cell = tableView.dequeue(CommentCell.self, for: indexPath)
        cell.configure(with: comment)
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
  }
  
  public func bindAction(reactor: R) {
    
    /// 리액터로 액션 전달해서 post 진행
    inputBox.rx.postButtonTap
      .withLatestFrom(inputBox.rx.text)
      .bind(with: self) { owner, text in
        print(text)
      }
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .debug()
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
