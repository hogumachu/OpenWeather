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
        self.items = []
        UIView.performWithoutAnimation {
            self.collectionView.reloadData()
        }
    }
    
    func configure(_ model: MainTodayWeatherCollectionTableViewCellModel) {
        self.items = model.collectionViewCellModels
        
        UIView.performWithoutAnimation {
            self.collectionView.reloadData()
        }
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
            make.height.equalTo(self.cellSize.height)
        }
    }
    
    private func setupAttributes() {
        self.selectionStyle = .none
        self.backgroundColor = .contentBackgroundColor
        
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
            $0.contentInset = .zero
        }
    }
    
    private var items: [MainTodayWeatherCollectionViewCellModel] = []
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    
    private let cellSize = CGSize(width: 70, height: 80)
    
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
