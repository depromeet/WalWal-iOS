//
//  WalWalFeed.swift
//  DesignSystem
//
//  Created by 이지희 on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public final class WalWalFeed: UIView {
  
  private typealias Colors = ResourceKitAsset.Colors
  
  // MARK: - Enums
  
  /// Boost효과 케이스에 따른 변수들을 정리
  public enum WalWalBurstString {
    case cute
    case cool
    case lovely
    
    var font: UIFont {
      switch self {
      case .cute: return ResourceKitFontFamily.LotteriaChab.Buster_Cute
      case .cool: return ResourceKitFontFamily.LotteriaChab.Buster_Cool
      case .lovely: return ResourceKitFontFamily.LotteriaChab.Buster_Lovely
      }
    }
    
    var normalText: String {
      switch self {
      case .cute: return "귀여워!"
      case .cool: return "멋져!"
      case .lovely: return "사랑스러워!"
      }
    }
    
    var goodText: String {
      switch self {
      case .cute: return "너무 귀여워!"
      case .cool: return "너무 멋져!"
      case .lovely: return "너무 사랑스러워!"
      }
    }
    
    var greatText: String {
      switch self {
      case .cute: return "너무너무 귀여워!"
      case .cool: return "너무너무 멋져!"
      case .lovely: return "너무너무 사랑스러워!"
      }
    }
  }
  
  // MARK: - Properties
  
  /// WalWalFeedModel의 데이터를 갖는 스트림
  public var feedData = BehaviorRelay<[WalWalFeedModel]>(value: [])
  
  private var longPressGesture: UILongPressGestureRecognizer!
  private var currentDetailView: WalWalFeedCellView?
  private var currentBackgroundView: UIView?
  private var currentBlackOverlayView: UIView?
  private var borderLayer: CAShapeLayer?
  private var centerLabels: [UILabel] = []
  private var centerShadowLabels: [UILabel] = []
  private var countLabel: UILabel?
  private var countTimer: Timer?
  private var count: Int = 0
  private let walwalEmitter = CAEmitterLayer()
  private let walwalCell = CAEmitterCell()
  private var isBorderFilled: Bool = false
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
  private let disposeBag = DisposeBag()
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: 342, height: 470)
    flowLayout.minimumLineSpacing = 14
    
    $0.collectionViewLayout = flowLayout
    $0.backgroundColor = .clear
    $0.register(WalWalFeedCell.self, forCellWithReuseIdentifier: "WalWalFeedCell")
    $0.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
  }
  
  // MARK: - Initializers
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  public init(feedData: [WalWalFeedModel]) {
    super.init(frame: .zero)
    setupView()
    self.feedData.accept(feedData)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    flex.layout()
    setupHeartEmitter()
  }
  
  // MARK: - Setup Methods
  
  private func setupView() {
    setupCollectionView()
    setupLongPressGesture()
    setupBindings()
    setLayouts()
  }
  
  private func setupCollectionView() {
    addSubview(collectionView)
  }
  
  /// LongPressGesture 셋업
  private func setupLongPressGesture() {
    longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    collectionView.addGestureRecognizer(longPressGesture)
  }
  
  private func setupBindings() {
    feedData
      .bind(to: collectionView.rx.items(cellIdentifier: "WalWalFeedCell", cellType: WalWalFeedCell.self)) { index, model, cell in
        cell.configureCell(feedData: model)
      }
      .disposed(by: disposeBag)
  }
  
  private func setLayouts() {
    flex.define { flex in
      flex.addItem(collectionView).grow(1)
    }
  }
  
  // MARK: - Gesture Handling
  
  @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
    case .began:
      feedbackGenerator.prepare() /// 햅틱 준비
      presentDetailView(for: gesture)
    case .ended, .cancelled:
      dismissDetailView()
      stopBorderAnimation()
      stopHeartAnimation()
      updateBoostCount(for: gesture) /// 제스쳐가 끝나면, 부스트카운트를 Cell에 업데이트
    default:
      break
    }
  }
  
  private func updateBoostCount(for gesture: UILongPressGestureRecognizer) {
    let point = gesture.location(in: collectionView)
    guard let indexPath = collectionView.indexPathForItem(at: point),
          var feedModel = feedData.value[safe: indexPath.item] else { return }
    feedModel.boostCount += count
    var updatedFeedData = feedData.value
    updatedFeedData[indexPath.item] = feedModel
    feedData.accept(updatedFeedData)
  }
  
  // MARK: - Detail View Presentation
  
  private func presentDetailView(for gesture: UILongPressGestureRecognizer) {
    let point = gesture.location(in: collectionView)
    guard let indexPath = collectionView.indexPathForItem(at: point),
          let cell = collectionView.cellForItem(at: indexPath) as? WalWalFeedCell,
          let feedModel = feedData.value[safe: indexPath.item] else { return }
    
    let detailView = WalWalFeedCellView(frame: cell.frame)
    detailView.configureFeed(feedData: feedModel)
    let cellFrameInWindow = cell.convert(cell.bounds, to: nil)
    detailView.frame = cellFrameInWindow
    
    guard let window = UIWindow.key else { return }
    
    /// 딤 처리 되는 뷰
    let backgroundView = createBackgroundView(frame: window.bounds)
    
    /// 선택된 Cell의 위치에 등장하는 암막
    let overlayView = createOverlayView(frame: cellFrameInWindow)
    
    window.addSubview(overlayView)
    window.addSubview(backgroundView)
    window.addSubview(detailView)
    
    /// Boost 케이스 랜덤 픽
    let burstCase = [WalWalBurstString.cute, WalWalBurstString.cool, WalWalBurstString.lovely].randomElement() ?? .cute
    
    /// 중앙에 등장하는 라벨 업데이트
    updateCenterLabels(with: burstCase.normalText, in: detailView, window: window, burstMode: burstCase)
    
    /// 카운팅 라벨 추가
    addCountLabel(to: window, detailView: detailView)
    
    /// 카운트를 증가시키기 위한 타이머 시작
    startCountTimer(in: detailView, window: window, burstCase: burstCase)
    
    /// 디테일 뷰 등장
    animateDetailViewAppearance(detailView, backgroundView: backgroundView, overlayView: overlayView)
    
    /// LongPress가 끝나면, 메모리에서 해제시키기 위한 변수 등록
    currentDetailView = detailView
    currentBackgroundView = backgroundView
    currentBlackOverlayView = overlayView
    
    /// 디테일뷰를 둘러쌀 외곽 선
    addBorderLayer(to: detailView)
    
    /// 외곽 선 애니메이션 시작 (초기색상)
    startBorderAnimation(borderColor: ResourceKitAsset.Colors.yellow.color)
    
    /// 부르르 애니메이션 시작
    addTiltAnimation()
  }
  
  private func createBackgroundView(frame: CGRect) -> UIView {
    let backgroundView = UIView(frame: frame)
    backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    backgroundView.alpha = 0
    return backgroundView
  }
  
  private func createOverlayView(frame: CGRect) -> UIView {
    let overlayView = UIView(frame: frame)
    overlayView.backgroundColor = Colors.white.color
    return overlayView
  }
  
  private func addCountLabel(to window: UIWindow, detailView: UIView) {
    count = 0
    countLabel = UILabel()
    let attrString = NSAttributedString(
      string: "\(count)",
      attributes: [
        .strokeColor: ResourceKitAsset.Colors.black.color,
        .foregroundColor: ResourceKitAsset.Colors.white.color,
        .strokeWidth: -7.0,
        .font: ResourceKitFontFamily.LotteriaChab.H1
      ]
    )
    countLabel?.attributedText = attrString
    countLabel?.textAlignment = .center
    countLabel?.sizeToFit()
    countLabel?.center = CGPoint(x: detailView.center.x, y: detailView.center.y - 40)
    countLabel?.alpha = 0
    window.addSubview(countLabel!)
  }
  
  private func animateDetailViewAppearance(_ detailView: UIView, backgroundView: UIView, overlayView: UIView) {
    detailView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    UIView.animate(withDuration: 0.3) {
      backgroundView.alpha = 1
      overlayView.alpha = 1
      detailView.transform = .identity
    }
  }
  
  // MARK: - Center Label Update
  
  private func updateCenterLabels(with text: String, in detailView: UIView, window: UIWindow, burstMode: WalWalBurstString) {
    
    /// 혹시나 남아있을 라벨들 정리
    clearExistingLabels()
    
    let words = text.split(separator: " ")
    var lines: [[String]] = [[]]
    let labelFont = burstMode.font
    let windowWidth = window.bounds.width
    var currentLineWidth: CGFloat = 0
    
    /// 텍스트가 두 줄로 나타날 경우를 고려해서 text 재정의
    for word in words {
      let wordWidth = calculateWordWidth(word, with: labelFont)
      if currentLineWidth + wordWidth > windowWidth {
        lines.append([String(word)])
        currentLineWidth = wordWidth
      } else {
        lines[lines.count - 1].append(String(word))
        currentLineWidth += wordWidth
      }
    }
    
    let countLabelY = detailView.center.y - 40
    var startY = countLabelY + 60
    
    for line in lines {
      let lineText = line.joined(separator: " ")
      /// 각 글자별로 Label처리 및 2줄 이상일 경우는, 적절한 비율(125%)로 상단 여백 추가
      addCharactersAsLabels(lineText, to: window, startY: &startY, detailView: detailView, labelFont: labelFont)
    }
  }
  
  private func clearExistingLabels() {
    centerLabels.forEach { $0.removeFromSuperview() }
    centerShadowLabels.forEach { $0.removeFromSuperview() }
    centerLabels.removeAll()
    centerShadowLabels.removeAll()
  }
  
  private func calculateWordWidth(_ word: String.SubSequence, with font: UIFont) -> CGFloat {
    let testLabel = UILabel()
    testLabel.attributedText = NSAttributedString(string: String(word), attributes: [.font: font])
    testLabel.sizeToFit()
    return testLabel.bounds.width
  }
  
  private func addCharactersAsLabels(_ text: String, to window: UIWindow, startY: inout CGFloat, detailView: UIView, labelFont: UIFont) {
    let characters = Array(text)
    var delay: TimeInterval = 0
    var totalWidth: CGFloat = 0
    
    for char in characters {
      totalWidth += calculateCharacterWidth(char, with: labelFont)
    }
    
    var startX = detailView.center.x - totalWidth / 2
    
    for char in characters {
      addCharacterLabel(char, to: window, startX: &startX, startY: startY, detailView: detailView, labelFont: labelFont, delay: &delay)
    }
    
    startY += labelFont.lineHeight - (labelFont.lineHeight * 0.25)
  }
  
  private func calculateCharacterWidth(_ char: Character, with font: UIFont) -> CGFloat {
    let testLabel = UILabel()
    testLabel.attributedText = NSAttributedString(string: String(char), attributes: [.font: font])
    testLabel.sizeToFit()
    return testLabel.bounds.width
  }
  
  private func addCharacterLabel(_ char: Character, to window: UIWindow, startX: inout CGFloat, startY: CGFloat, detailView: UIView, labelFont: UIFont, delay: inout TimeInterval) {
    
    /// 그림자 역할을 할 라벨
    let shadowLabel = createShadowLabel(for: char, font: labelFont)
    
    /// 외곽선을 가진 메인 라벨
    let label = createCharacterLabel(for: char, font: labelFont)
    
    centerLabels.append(label)
    centerShadowLabels.append(shadowLabel)
    
    let initialY = startY + window.bounds.height / 2
    shadowLabel.center = CGPoint(x: startX + shadowLabel.bounds.width / 2 + 4, y: initialY + 4)
    label.center = CGPoint(x: startX + label.bounds.width / 2, y: initialY)
    startX += label.bounds.width
    
    window.addSubview(shadowLabel)
    window.addSubview(label)
    
    UIView.animate(withDuration: 0.5, delay: delay, options: [], animations: {
      shadowLabel.alpha = 1
      shadowLabel.center.y = startY + 4
      label.alpha = 1
      label.center.y = startY
    }, completion: nil)
    
    delay += 0.1
  }
  
  private func createShadowLabel(for char: Character, font: UIFont) -> UILabel {
    let shadowLabel = UILabel()
    let shadowAttrString = NSAttributedString(
      string: String(char),
      attributes: [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.black,
        .strokeWidth: -4,
        .font: font
      ]
    )
    shadowLabel.attributedText = shadowAttrString
    shadowLabel.textAlignment = .center
    shadowLabel.sizeToFit()
    shadowLabel.alpha = 0
    return shadowLabel
  }
  
  private func createCharacterLabel(for char: Character, font: UIFont) -> UILabel {
    let label = UILabel()
    let attrString = NSAttributedString(
      string: String(char),
      attributes: [
        .strokeColor: ResourceKitAsset.Colors.black.color,
        .font: font,
        .foregroundColor: ResourceKitAsset.Colors.white.color,
        .strokeWidth: -4
      ]
    )
    label.attributedText = attrString
    label.textAlignment = .center
    label.sizeToFit()
    label.alpha = 0
    return label
  }
  
  // MARK: - Border Animation
  
  private func addBorderLayer(to view: UIView) {
    borderLayer = CAShapeLayer()
    let path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 20)
    borderLayer?.path = path.cgPath
    borderLayer?.fillColor = UIColor.clear.cgColor
    borderLayer?.lineWidth = 5
    borderLayer?.strokeEnd = 0
    view.layer.addSublayer(borderLayer!)
  }
  
  private func startBorderAnimation(borderColor: UIColor, isRainbow: Bool = false) {
    if isRainbow {
      startRainbowBorderAnimation()
    } else {
      startDefaultBorderAnimation(borderColor: borderColor)
    }
  }
  
  private func startRainbowBorderAnimation() {
    let colors: [CGColor] = [
      ResourceKitAsset.Colors.pink.color.cgColor,
      ResourceKitAsset.Colors.walwalOrange.color.cgColor,
      ResourceKitAsset.Colors.yellow.color.cgColor,
      ResourceKitAsset.Colors.green.color.cgColor,
      ResourceKitAsset.Colors.skyblue.color.cgColor,
      ResourceKitAsset.Colors.blue.color.cgColor,
      ResourceKitAsset.Colors.purple.color.cgColor,
      ResourceKitAsset.Colors.pink.color.cgColor
    ]
    
    let rainbowAnimation = CAKeyframeAnimation(keyPath: "strokeColor")
    rainbowAnimation.values = colors
    rainbowAnimation.keyTimes = [0, 0.14, 0.28, 0.43, 0.58, 0.72, 0.87,  1.0]
    rainbowAnimation.duration = 5.0 /// 애니메이션 지속 시간
    rainbowAnimation.repeatCount = .infinity
    
    borderLayer?.add(rainbowAnimation, forKey: "rainbowBorderAnimation")
  }
  
  private func addTiltAnimation() {
    let tiltAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
    let frames = 144 /// 틱당 생기는 부자연스러움을 없애기 위하 144fps로 애니메이션 설정
    var values = [Double]()
    var keyTimes = [NSNumber]()
    
    for i in 0...frames {
      let progress = Double(i) / Double(frames)
      let angle = sin(progress * 2 * .pi) * (Double.pi / 24) /// 15도 각도를 1frame 만큼 각도 변환
      values.append(angle)
      keyTimes.append(NSNumber(value: progress))
    }
    
    tiltAnimation.values = values
    tiltAnimation.keyTimes = keyTimes
    tiltAnimation.duration = 0.3 /// 144프레임의 애니메이션을 1초 동안
    tiltAnimation.repeatCount = .infinity /// 무한 반복
    
    currentDetailView?.layer.add(tiltAnimation, forKey: "tilt")
  }
  
  private func startDefaultBorderAnimation(borderColor: UIColor) {
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = 2.5 /// 1 ~ 49 | 50 ~ 99 | 100 ~ 150 -> 각 2.5초씩임. 따라서 외곽선 애니메이션도 2.5초
    animation.isRemovedOnCompletion = false
    animation.fillMode = .forwards
    
    animation.delegate = self
    
    borderLayer?.strokeColor = borderColor.cgColor
    borderLayer?.add(animation, forKey: "borderAnimation")
  }
  
  private func stopBorderAnimation() {
    borderLayer?.removeAllAnimations()
    borderLayer?.removeFromSuperlayer()
    borderLayer = nil
  }
  
  // MARK: - Timer and Count Handling
  
  private func startCountTimer(in detailView: UIView, window: UIWindow, burstCase: WalWalBurstString) {
    countTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
      self?.handleCountTimerTick(in: detailView, window: window, burstCase: burstCase)
    }
  }
  
  private func handleCountTimerTick(in detailView: UIView, window: UIWindow, burstCase: WalWalBurstString) {
    count += 1
    updateCountLabel()
    
    /// 부스트 카운트가 10이 넘어가면, Boost애니메이션 시작 및 카운트라벨 등장
    if count >= 10 {
      showCountLabelIfNeeded()
      startWalWalAnimation()
    }
    
    /// 햅틱은 지속 작용
    feedbackGenerator.impactOccurred()
    
    switch count {
    case 50:
      updateCenterLabels(with: burstCase.goodText, in: detailView, window: window, burstMode: burstCase)
      startBorderAnimation(borderColor: ResourceKitAsset.Colors.walwalOrange.color)
    case 100:
      updateCenterLabels(with: burstCase.greatText, in: detailView, window: window, burstMode: burstCase)
      startBorderAnimation(borderColor: .red)
    case 150:
      startBorderAnimation(borderColor: .clear, isRainbow: true)
    default:
      break
    }
  }
  
  private func updateCountLabel() {
    let attrString = NSAttributedString(
      string: "\(count)",
      attributes: [
        .strokeColor: ResourceKitAsset.Colors.black.color,
        .foregroundColor: ResourceKitAsset.Colors.white.color,
        .strokeWidth: -6.73,
        .font: ResourceKitFontFamily.LotteriaChab.H1
      ]
    )
    countLabel?.attributedText = attrString
    countLabel?.sizeToFit()
    countLabel?.center = CGPoint(x: currentDetailView!.center.x, y: currentDetailView!.center.y - 50)
  }
  
  private func showCountLabelIfNeeded() {
    if countLabel?.alpha == 0 {
      UIView.animate(withDuration: 1.0) {
        self.countLabel?.alpha = 1
      }
    }
  }
  
  private func stopCountTimer() {
    countTimer?.invalidate()
    countTimer = nil
  }
  
  // MARK: - Detail View Dismiss
  
  private func dismissDetailView() {
    guard let detailView = currentDetailView,
          let backgroundView = currentBackgroundView,
          let overlayView = currentBlackOverlayView else { return }
    
    backgroundView.removeFromSuperview()
    detailView.removeFromSuperview()
    overlayView.removeFromSuperview()
    
    clearExistingLabels()
    countLabel?.removeFromSuperview()
    stopCountTimer()
    
    currentDetailView = nil
    currentBackgroundView = nil
    currentBlackOverlayView = nil
    stopBorderAnimation()
    stopHeartAnimation()
  }
  
  // MARK: - Heart Emitter
  
  private func setupHeartEmitter() {
    walwalEmitter.emitterShape = .sphere
    walwalEmitter.emitterMode = .outline
    walwalEmitter.renderMode = .additive
    
    walwalCell.contents = ResourceKitAsset.Sample.walwalEmitterDog.image.cgImage
    walwalCell.scale = 0.8 /// 이미지의 크기 80
    walwalCell.scaleRange = 0.5 /// 80 ~ 130까지의 범위
    walwalCell.lifetime = 2.0 /// 2초 동안 존재
    walwalCell.lifetimeRange = 0.5 /// 2.0 ~ 2.5초 사이 랜덤 시간 생존
    walwalCell.birthRate = 0 /// 초기 파티클 0개
    walwalCell.velocity = 800 /// 속도 800
    walwalCell.velocityRange = 50 /// 속도의 범위 800 ~ 850
    walwalCell.emissionRange = .pi * 2 /// 360도
    walwalCell.spin = 3.14 /// 180도
    walwalCell.spinRange = 6.28 /// 360도
    walwalCell.alphaSpeed = -0.5 /// 50%의 투명도
    
    walwalEmitter.emitterCells = [walwalCell]
  }
  
  private func startWalWalAnimation() {
    guard let detailView = currentDetailView else { return }
    
    /// 에미터 위치 설정
    walwalEmitter.emitterPosition = CGPoint(x: detailView.bounds.width / 2, y: detailView.bounds.height / 2)
    
    /// 에미터 범위 설정
    walwalEmitter.emitterSize = CGSize(width: detailView.bounds.width / 2, height: detailView.bounds.width / 2)
    
    walwalCell.birthRate = 30
    
    detailView.layer.addSublayer(walwalEmitter)
  }
  
  private func stopHeartAnimation() {
    walwalCell.birthRate = 0
    walwalEmitter.removeFromSuperlayer()
  }
}

// MARK: - Array Extension

extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

// MARK: - Animation Delegate

extension WalWalFeed: CAAnimationDelegate {
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag {
      isBorderFilled = true
    }
  }
}
