//
//  MainView.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then

final class MainView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showSearchView() {
        guard self.isSearchTextFieldHidden == true else { return }
        self.isSearchTextFieldHidden = false
        self.searchTextFieldTopConstraint?.update(offset: 40)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func hideSearchView() {
        guard self.isSearchTextFieldHidden == false else { return }
        self.isSearchTextFieldHidden = true
        self.searchTextFieldTopConstraint?.update(offset: -40)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func updateCurrentWeather(weather: String?) {
        guard let named = weather else { return }
        self.backgroundImageView.image = UIImage(named: named)
    }
    
    private func setupLayout() {
        self.addSubview(self.backgroundImageView)
        self.backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.searchTextField)
        self.searchTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
            self.searchTextFieldTopConstraint = make.top.equalToSuperview().offset(40).constraint
        }
        
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchTextField.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .clear
        
        self.backgroundImageView.do {
            $0.backgroundColor = .systemBlue
            $0.contentMode = .scaleAspectFill
        }
        
        self.searchTextField.do {
            $0.isTextFieldEnabled = false
        }
        
        self.tableView.do {
            $0.backgroundColor = .clear
            $0.registerCell(cell: MainHeaderTableViewCell.self)
            $0.registerCell(cell: MainTitleTableViewCell.self)
            $0.registerCell(cell: MainTodayWeatherCollectionTableViewCell.self)
            $0.registerCell(cell: MainWeatherTableViewCell.self)
            $0.registerCell(cell: MainPrecipitationTableViewCell.self)
            $0.registerCell(cell: MainETCTCollectionTableViewCell.self)
            $0.separatorColor = .secondaryColor
            $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private var isSearchTextFieldHidden = false
    private var searchTextFieldTopConstraint: Constraint?
    
    let backgroundImageView = UIImageView(frame: .zero)
    let searchTextField = CommonTextField(frame: .zero)
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
}
