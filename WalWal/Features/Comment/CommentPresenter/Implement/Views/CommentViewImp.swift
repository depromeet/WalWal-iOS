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
  
  public var disposeBag = DisposeBag()
  public var commentReactor: R
  
  private let commentLabel = CustomLabel(font: <#T##UIFont#>, ).then {
    $0.text = "댓글"
    $0.font = .boldSystemFont(ofSize: 20)
  }
  
  private let tableView = UITableView().then {
    $0.register(CommentCell.self)
    $0.separatorStyle = .none
    $0.showsVerticalScrollIndicator = false
  }
  
  private var dataSource: UITableViewDiffableDataSource<Section, FlattenCommentModel>!
  
  public init(reactor: R) {
    self.commentReactor = reactor
    super.init(nibName: nil, bundle: nil)
    
    commentReactor.action.onNext(.fetchComments(recordId: 123))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setAttribute()
    setupTableView()
    setupDataSource()
    bind(reactor: commentReactor)
  }
  
  // MARK: - UI Setup
  public func setAttribute() {
    view.backgroundColor = .white
    view.addSubview(tableView)
    tableView.pin.all() // PinLayout을 사용하여 테이블뷰 레이아웃 설정
  }
  
  public func setLayout() { }
  
  private func setupTableView() {
    tableView.delegate = self
  }
  
  private func setupDataSource() {
    dataSource = UITableViewDiffableDataSource<Section, FlattenCommentModel>(tableView: tableView) { (tableView, indexPath, comment) -> UITableViewCell? in
      let cell = tableView.dequeue(CommentCell.self, for: indexPath)
      cell.configure(with: comment)
      return cell
    }
  }
  
  private func updateSnapshot(with comments: [FlattenCommentModel]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, FlattenCommentModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(comments, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
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
    
  }
  
  public func bindEvent() {
    
  }
  
}

// MARK: - Section Enum
enum Section {
  case main
}
