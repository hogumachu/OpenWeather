//
//  SearchTableViewCell.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/25.
//

import UIKit
import SnapKit
import Then

struct SearchTableViewCellModel {
    
    let city: String
    let country: String
    
}

final class SearchTableViewCell: UITableViewCell {
    
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
        self.cityLabel.text = nil
        self.countryLabel.text = nil
    }
    
    func configure(_ model: SearchTableViewCellModel) {
        self.cityLabel.text = model.city
        self.countryLabel.text = model.country
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.cityLabel)
        self.cityLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.contentView.addSubview(self.countryLabel)
        self.countryLabel.snp.makeConstraints { make in
            make.top.equalTo(self.cityLabel.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupAttributes() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.cityLabel.do {
            $0.textColor = .mainColor
            $0.font = .systemFont(ofSize: 17, weight: .bold)
        }
        
        self.countryLabel.do {
            $0.textColor = .mainColor
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
    }
    
    private let cityLabel = UILabel(frame: .zero)
    private let countryLabel = UILabel(frame: .zero)
    
}
