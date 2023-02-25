//
//  MainView.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then

typealias MainViewDelegate = CommonTextFieldTextFieldDelegate & UITableViewDelegate
typealias MainViewDataSource = UITableViewDataSource

final class MainView: UIView {
    
    weak var delegate: MainViewDelegate? {
        didSet {
            self.searchTextField.delegate = self.delegate
            self.tableView.delegate = self.delegate
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
    }
    
    private func setupLayout() {
        self.addSubview(self.searchTextField)
        self.searchTextField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchTextField.snp.bottom).offset(3)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.tableView.do {
            $0.backgroundColor = .systemBlue
            $0.registerCell(cell: MainTitleTableViewCell.self)
            $0.registerCell(cell: MainTodayWeatherCollectionTableViewCell.self)
            $0.registerCell(cell: MainWeatherTableViewCell.self)
            $0.registerCell(cell: MainPrecipitationTableViewCell.self)
            $0.registerCell(cell: MainETCTCollectionTableViewCell.self)
            $0.separatorColor = .white.withAlphaComponent(0.6)
            $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private let searchTextField = CommonTextField(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
}
