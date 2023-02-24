//
//  MainTodayWeatherCollectionTableViewCell.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then

struct MainTodayWeatherCollectionTableViewCellModel {
    
    let title: String?
    let collectionViewCellModels: [MainTodayWeatherCollectionViewCellModel]
    
}

final class MainTodayWeatherCollectionTableViewCell: UITableViewCell {
    
    typealias CellType = MainTodayWeatherCollectionViewCell
    
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
        self.titleLabel.text = nil
        self.items = []
        UIView.performWithoutAnimation {
            self.collectionView.reloadData()
        }
    }
    
    func configure(_ model: MainTodayWeatherCollectionTableViewCellModel) {
        self.titleLabel.text = model.title
        
        self.items = model.collectionViewCellModels
        
        UIView.performWithoutAnimation {
            self.collectionView.reloadData()
        }
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.containerView.addSubview(self.separator)
        self.separator.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        self.containerView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.separator.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(self.cellSize.height)
        }
    }
    
    private func setupAttributes() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.containerView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.2)
            $0.layer.cornerRadius = 8
        }
        
        self.titleLabel.do {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
        self.separator.do {
            $0.backgroundColor = .white
        }
        
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.itemSize = self.cellSize
        }
        
        self.collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.registerCell(cell: CellType.self)
            $0.backgroundColor = .clear
            $0.collectionViewLayout = flowLayout
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    private var items: [MainTodayWeatherCollectionViewCellModel] = []
    
    private let containerView = UIView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let separator = UIView(frame: .zero)
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    
    // TODO: - Change
    private let cellSize = CGSize(width: 80, height: 100)
    
}

extension MainTodayWeatherCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Do Something
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension MainTodayWeatherCollectionTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(cell: CellType.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        guard let model = self.items[safe: indexPath.item] else {
            return cell
        }
        cell.configure(model)
        return cell
    }
    
}
