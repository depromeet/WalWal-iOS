//
//  TermsViewControllerImp.swift
//  MyPagePresenterImp
//
//  Created by Jiyeon on 8/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import MyPagePresenter
import ResourceKit
import DesignSystem

import FlexLayout
import PinLayout
import Then
import ReactorKit
import RxCocoa

public final class TermsViewControllerImp<R: TermsReactor>: UIViewController, TermsViewController {
  
  private typealias FontKR = ResourceKitFontFamily.KR
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let navigationBar: WalWalNavigationBar
  private let textView = UITextView().then {
    $0.isEditable = false
    $0.isScrollEnabled = true
    $0.font = FontKR.B2
    $0.showsVerticalScrollIndicator = false
    $0.isSelectable = false
  }
  
  // MARK: - Properties
  
  public var termsReactor: R
  public var disposeBag = DisposeBag()
  private let termType: TermsType
  
  // MARK: - Initialize
  
  public init(
    reactor: R,
    termType: TermsType
  ) {
    self.termsReactor = reactor
    self.termType = termType
    navigationBar = WalWalNavigationBar(
      leftItems: [],
      title: termType.title,
      rightItems: [.darkClose],
      rightItemSize: 40
    )
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.reactor = termsReactor
    view.backgroundColor = ResourceKitAsset.Colors.white.color
    textView.text = LegalText.serviceTerms
    textView.applyFormattedText(termType.text)
    setAttribute()
    setLayout()
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin
      .all(view.pin.safeArea)
    
    rootContainer.flex
      .layout()
  }
  
  public func setAttribute() {
    view.addSubview(rootContainer)
    [navigationBar, textView].forEach {
      rootContainer.addSubview($0)
    }
  }
  
  public func setLayout() {
    rootContainer.flex
      .justifyContent(.start)
    
    navigationBar.flex
      .width(100%)
    
    textView.flex
      .grow(1)
      .marginHorizontal(20)
  }
  
}

// MARK: - Binding

extension TermsViewControllerImp: View {
  
  public func bind(reactor: R) {
    navigationBar.rightItems?.first?.rx.tapped
      .map { Reactor.Action.close }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

// MARK: - TermsType

fileprivate extension TermsType {
  var title: String {
    switch self {
    case .service:
      return "서비스 이용약관"
    case .privacy:
      return "개인정보처리방침"
    }
  }
  var text: String {
    switch self {
    case .service:
      return LegalText.serviceTerms
    case .privacy:
      return LegalText.privacyPolicy
    }
  }
}

// MARK: - TextView+

fileprivate extension UITextView {
  private typealias FontKR = ResourceKitFontFamily.KR
  func applyFormattedText(_ text: String) {
    // 전체 텍스트에 대한 기본 속성 설정
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 6
    
    let attributes: [NSAttributedString.Key: Any] = [
      .font: FontKR.B2,
      .paragraphStyle: paragraphStyle
    ]
    
    // NSMutableAttributedString 생성
    let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
    
    // "제 x조(내용)" 패턴에 대해 제목 스타일 적용
    let titleFont = FontKR.H7.B
    let titleAttributes: [NSAttributedString.Key: Any] = [
      .font: titleFont
    ]
    
    let titlePattern = "제 \\d{1,2}조\\(.*?\\)"
    let titleRegex = try! NSRegularExpression(pattern: titlePattern, options: [])
    let titleMatches = titleRegex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
    
    for match in titleMatches {
      attributedText.addAttributes(titleAttributes, range: match.range)
    }
    if let range = text.range(of: "부칙") {
      let nsRange = NSRange(range, in: text)
      attributedText.addAttributes(titleAttributes, range: nsRange)
    }
    
    // 숫자 리스트와 서브 리스트에 대해 들여쓰기 적용
    let listPatterns = ListRegex.allCases
    
    for pattern in listPatterns {
      let regex = try! NSRegularExpression(pattern: pattern.rawValue, options: [])
      let matches = regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
      
      for match in matches {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = pattern.firstIndet // 첫 줄 들여쓰기
        paragraphStyle.headIndent = pattern.headIndent // 나머지 줄 들여쓰기
        paragraphStyle.lineSpacing = 6 // 줄 간격 설정
        
        // 특정 리스트 항목이 끝나는 위치 계산
        let listRange = match.range
        let nextIndex = listRange.location + listRange.length
        
        // 다음 리스트 항목이나 줄 끝 위치까지 반복
        var endOfListRange = nextIndex
        while endOfListRange < attributedText.length {
          let nextCharacter = attributedText.string[attributedText.string.index(attributedText.string.startIndex, offsetBy: endOfListRange)]
          if nextCharacter == "\n" || nextCharacter == " " {
            endOfListRange += 1
          } else {
            break
          }
        }
        
        let fullListRange = NSRange(location: listRange.location, length: endOfListRange - listRange.location)
        
        attributedText.addAttributes([.paragraphStyle: paragraphStyle], range: fullListRange)
      }
    }
    
    // UITextView에 설정된 AttributedString 적용
    self.attributedText = attributedText
  }
  
  enum ListRegex: String, CaseIterable {
    case numeric = "\\d+\\."
    case alphabet = "[a-z]\\."
    
    var firstIndet: CGFloat {
      switch self {
      case .numeric:
        return 0
      case .alphabet:
        return 18
      }
    }
    var headIndent: CGFloat {
      switch self {
      case .numeric:
        return 15
      case .alphabet:
        return 33
      }
    }
  }
}
