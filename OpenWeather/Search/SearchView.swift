//
//  SearchView.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then

typealias SearchViewDelegate = CommonTextFieldTextFieldDelegate & UITableViewDelegate
typealias SearchViewDataSource = UITableViewDataSource

final class SearchView: UIView {
    
    weak var delegate: SearchViewDelegate? {
        didSet {
            self.searchTextField.delegate = self.delegate
            self.tableView.delegate = self.delegate
        }
    }
    
    weak var dataSource: SearchViewDataSource? {
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
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchTextField.snp.bottom).offset(3)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .black.withAlphaComponent(0.8)
        
        self.searchTextField.do {
            $0.isTextFieldEnabled = true
        }
        
        self.tableView.do {
            $0.backgroundColor = .clear
            $0.registerCell(cell: SearchTableViewCell.self)
            $0.separatorColor = .secondaryColor
            $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    private let searchTextField = CommonTextField(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
}
