//
//  MainHeaderTableViewCell.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then

struct MainHeaderTableViewCellModel {
    
    let city: String?
    let temp: String?
    let weather: String?
    let tempDetail: String?
    
}

final class MainHeaderTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: MainHeaderTableViewCellModel) {
        self.cityLabel.text = model.city
        self.tempLabel.text = model.temp
        self.weatherLabel.text = model.weather
        self.tempDetailLabel.text = model.tempDetail
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.labelStackView)
        self.labelStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        }
        
        self.labelStackView.addArrangedSubview(self.cityLabel)
        self.labelStackView.addArrangedSubview(self.tempLabel)
        self.labelStackView.addArrangedSubview(self.weatherLabel)
        self.labelStackView.addArrangedSubview(self.tempDetailLabel)
    }
    
    private func setupAttributes() {
        self.backgroundColor = .clear
        
        self.containerView.do {
            $0.backgroundColor = .clear
        }
        
        self.labelStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 5
        }
        
        self.cityLabel.do {
            $0.textColor = .mainColor
            $0.font = .systemFont(ofSize: 40, weight: .regular)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        self.tempLabel.do {
            $0.textColor = .mainColor
            $0.font = .systemFont(ofSize: 80, weight: .semibold)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        self.weatherLabel.do {
            $0.textColor = .mainColor
            $0.font = .systemFont(ofSize: 30, weight: .regular)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        self.tempDetailLabel.do {
            $0.textColor = .mainColor
            $0.font = .systemFont(ofSize: 22, weight: .regular)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let labelStackView = UIStackView(frame: .zero)
    private let cityLabel = UILabel(frame: .zero)
    private let tempLabel = UILabel(frame: .zero)
    private let weatherLabel = UILabel(frame: .zero)
    private let tempDetailLabel = UILabel(frame: .zero)
    
}
