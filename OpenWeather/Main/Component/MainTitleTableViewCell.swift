//
//  MainTitleTableViewCell.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then

struct MainTitleTableViewCellModel {
    
    let title: String?
    let style: MainTitleTableViewCellStyle
    
    enum MainTitleTableViewCellStyle {
        
        case normal
        case secondary
        
        var textColor: UIColor {
            switch self {
            case .normal:       return .mainColor
            case .secondary:    return .secondaryColor
            }
        }
    }
    
}

final class MainTitleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: MainTitleTableViewCellModel, inset: UIEdgeInsets = .zero) {
        self.titleLabel.text = model.title
        self.titleLabel.textColor = model.style.textColor
        
        self.titleLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(inset)
        }
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.selectionStyle = .none
        self.backgroundColor = .contentBackgroundColor
        
        self.titleLabel.do {
            $0.textColor = .mainColor
            $0.font = .systemFont(ofSize: 13, weight: .regular)
        }
    }
    
    private let titleLabel = UILabel(frame: .zero)
    
}
