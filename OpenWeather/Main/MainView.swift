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
    
    weak var delegate: UITableViewDelegate? {
        didSet { self.tableView.delegate = self.delegate }
    }
    
    weak var dataSource: UITableViewDataSource? {
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
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
}
