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
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateSheetUp()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    dimView.pin.all()
    dimView.flex.layout()
    rootContainerView.pin.bottom(-rootContainerView.frame.height)
    rootContainerView.flex
      .layout()
  }
  
  // MARK: - UI Setup
  public func setAttribute() {
    view.backgroundColor = .clear
    view.addSubview(dimView)
    
    rootContainerView.layer.cornerRadius = 30
    rootContainerView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    setupTableView()
    setupDataSource()
  }
  
  public func setLayout() {
    dimView.flex
      .define { flex in
        flex.addItem(rootContainerView)
          .position(.absolute)
          .bottom(0)
          .width(100%)
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
    
    rootContainerView.flex
      .height(580.adjustedHeight)
      .define { flex in
        flex.addItem(headerContainerView)
        flex.addItem(tableViewContainerView)
      }
  }
  
  private func animateSheetUp() {
    UIView.animate(withDuration: 0.3) {
      self.dimView.alpha = 1
      self.rootContainerView.pin.bottom(0)
      self.rootContainerView.flex.layout()
    }
  }
  
  private func animateSheetDown(completion: (() -> Void)? = nil) {
    UIView.animate(withDuration: 0.3, animations: {
      self.dimView.alpha = 0
      self.rootContainerView.pin.bottom(-self.rootContainerView.frame.height)
      self.rootContainerView.flex.layout()
    }, completion: { _ in
      completion?()
    })
  }
  
  private func updateSheetPosition(_ position: CGFloat) {
    if position > 0 {
      rootContainerView.pin.bottom(-position)
    } else {
      animateSheetUp()
    }
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
    rootContainerView.rx
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
        owner.animateSheetDown {
          reactor.action.onNext(.tapDimView)
        }
      })
      .disposed(by: disposeBag)
    
  }
  
  public func bindEvent() {
    
  }
  
}

// MARK: - Section Enum
enum Section {
  case main
}
