//
//  MainETCCollectionViewCell.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then

struct MainETCCollectionViewCellModel {
    
    let title: String
    let content: String
    let description: String?
    
}

final class MainETCCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.contentLabel.text = nil
        self.descriptionLabel.text = nil
    }
    
    func configure(_ model: MainETCCollectionViewCellModel) {
        self.titleLabel.text = model.title
        self.contentLabel.text = model.content
        self.descriptionLabel.text = model.description
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.containerView.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.containerView.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .clear
        
        self.containerView.do {
            $0.backgroundColor = .contentBackgroundColor
            $0.layer.cornerRadius = 10
        }
        
        self.titleLabel.do {
            $0.textColor = .secondaryColor
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
        self.contentLabel.do {
            $0.textColor = .mainColor
            $0.font = .systemFont(ofSize: 25, weight: .regular)
            $0.numberOfLines = 0
        }
        
        self.descriptionLabel.do {
            $0.textColor = .secondaryColor
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let contentLabel = UILabel(frame: .zero)
    private let descriptionLabel = UILabel(frame: .zero)
    
}
