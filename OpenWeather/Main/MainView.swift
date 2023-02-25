//
//  MainView.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then

protocol MainViewDelegate: CommonTextFieldTextFieldDelegate & UITableViewDelegate {
    
    var currentWeather: String? { get }
    
}

typealias MainViewDataSource = UITableViewDataSource

final class MainView: UIView {
    
    weak var delegate: MainViewDelegate? {
        didSet {
            self.searchTextField.delegate = self.delegate
            self.tableView.delegate = self.delegate
            self.updateBackground()
        }
    }
    
    weak var dataSource: MainViewDataSource? {
        didSet { self.tableView.dataSource = self.dataSource }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        self.tableView.reloadData()
        self.updateBackground()
    }
    
    func showSearchView() {
        self.searchTextFieldTopConstraint?.update(offset: 40)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func hideSearchView() {
        self.searchTextFieldTopConstraint?.update(offset: -40)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func updateBackground() {
        guard let named = self.delegate?.currentWeather else { return }
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
        
        self.tableView.do {
            $0.backgroundColor = .clear
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
    
    private var searchTextFieldTopConstraint: Constraint?
    
    private let backgroundImageView = UIImageView(frame: .zero)
    private let searchTextField = CommonTextField(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
}
