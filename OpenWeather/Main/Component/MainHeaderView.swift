//
//  MainHeaderView.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then

struct MainHeaderViewModel {
    
    let city: String?
    let temp: String?
    let weather: String?
    let tempDetail: String?
    
}

final class MainHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: MainHeaderViewModel) {
        self.cityLabel.text = model.city
        self.tempLabel.text = model.temp
        self.weatherLabel.text = model.weather
        self.tempDetailLabel.text = model.tempDetail
    }
    
    private func setupLayout() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.labelStackView)
        self.labelStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.labelStackView.addArrangedSubview(self.cityLabel)
        self.labelStackView.addArrangedSubview(self.tempLabel)
        self.labelStackView.addArrangedSubview(self.weatherLabel)
        self.labelStackView.addArrangedSubview(self.tempDetailLabel)
    }
    
    private func setupAttributes() {
        self.containerView.do {
            $0.backgroundColor = .clear
        }
        
        self.labelStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 5
        }
        
        self.cityLabel.do {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 25, weight: .bold)
            $0.textAlignment = .center
        }
        
        self.tempLabel.do {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 30, weight: .heavy)
            $0.textAlignment = .center
        }
        
        self.weatherLabel.do {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 20, weight: .bold)
            $0.textAlignment = .center
        }
        
        self.tempDetailLabel.do {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
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
