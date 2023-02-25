//
//  MainTodayWeatherCollectionViewCell.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

struct MainTodayWeatherCollectionViewCellModel {
    
    let time: String
    let icon: String
    let temp: String
    
}

final class MainTodayWeatherCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttirubtes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.timeLabel.text = nil
        self.weatherImageView.image = nil
        self.weatherImageView.kf.cancelDownloadTask()
        self.tempLabel.text = nil
    }
    
    func configure(_ model: MainTodayWeatherCollectionViewCellModel) {
        self.timeLabel.text = model.time
        self.weatherImageView.kf.setImage(with: URL(string: model.icon))
        self.tempLabel.text = model.temp
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.contentView.addSubview(self.tempLabel)
        self.tempLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.contentView.addSubview(self.weatherImageView)
        self.weatherImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
    }
    
    private func setupAttirubtes() {
        self.timeLabel.do {
            $0.textColor = .mainColor
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            $0.textAlignment = .center
        }
        
        self.weatherImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        self.tempLabel.do {
            $0.textColor = .mainColor
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            $0.textAlignment = .center
        }
    }
    
    private let timeLabel = UILabel(frame: .zero)
    private let weatherImageView = UIImageView(frame: .zero)
    private let tempLabel = UILabel(frame: .zero)
    
}
