//
//  WalWalProfileCardView.swift
//  DesignSystem
//
//  Created by 조용인 on 8/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import FlexLayout
import PinLayout
import Then

public class WalWalProfileCardView: UIView {
  
  // MARK: - UI
  
  private let containerView = UIView()
  
  private let profileImageView = UIImageView()
  
  private let nameLabel = UILabel()
  
  private let descriptionLabel = UILabel()
  
  private let actionButton = UIButton() /// 해당 버튼은 차후, WalWalButton으로 대체됨
  
  // MARK: - Properties
  private let disposeBag = DisposeBag()
  
  // MARK: - Initialization
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  private func setupView() {
    addSubview(containerView)
    
    containerView.flex.define { flex in
      flex.addItem().direction(.row).alignItems(.center).padding(12).define { flex in
        flex.addItem(profileImageView).size(60).marginRight(12)
        flex.addItem().grow(1).define { flex in
          flex.addItem(nameLabel)
          flex.addItem(descriptionLabel).marginTop(4)
        }
        flex.addItem(actionButton).marginLeft(12)
      }
    }
    
    setupStyles()
  }
  
  private func setupStyles() {
    backgroundColor = .white
    layer.cornerRadius = 16
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 4
    
    profileImageView.layer.cornerRadius = 30
    profileImageView.clipsToBounds = true
    profileImageView.contentMode = .scaleAspectFill
    
    nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    nameLabel.textColor = .black
    
    descriptionLabel.font = UIFont.systemFont(ofSize: 14)
    descriptionLabel.textColor = .gray
    
    actionButton.setTitle("수정", for: .normal)
    actionButton.setTitleColor(.white, for: .normal)
    actionButton.backgroundColor = .systemBlue
    actionButton.layer.cornerRadius = 8
    actionButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
  }
  
  // MARK: - Layout
  public override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin.all()
    containerView.flex.layout()
  }
  
  // MARK: - Public Methods
  public func configure(with profileImage: UIImage, name: String, description: String) {
    profileImageView.image = profileImage
    nameLabel.text = name
    descriptionLabel.text = description
  }
  
  public var actionTap: ControlEvent<Void> {
    return actionButton.rx.tap
  }
}
