//
//  MainWeatherTableViewCell.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then

struct MainWeatherTableViewCellModel {
    
    let dayOfWeek: String
    let icon: String
    let temp: String
    
}

final class MainWeatherTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dayOfWeekLabel.text = nil
        self.iconImageView.image = nil
        self.iconImageView.kf.cancelDownloadTask()
        self.tempLabel.text = nil
    }
    
    func configure(_ model: MainWeatherTableViewCellModel) {
        self.dayOfWeekLabel.text = model.dayOfWeek
        self.iconImageView.kf.setImage(with: URL(string: model.icon))
        self.tempLabel.text = model.temp
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.dayOfWeekLabel)
        self.dayOfWeekLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        self.contentView.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.leading.equalToSuperview().offset(70)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(self.tempLabel)
        self.tempLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupAttributes() {
        self.selectionStyle = .none
        self.backgroundColor = .contentBackgroundColor
        
        self.dayOfWeekLabel.do {
            $0.textColor = .mainColor
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        self.iconImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        self.tempLabel.do {
            $0.textColor = .mainColor
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
    }
    
    private let dayOfWeekLabel = UILabel(frame: .zero)
    private let iconImageView = UIImageView(frame: .zero)
    private let tempLabel = UILabel(frame: .zero)
    
}
