//
//  MainETCTCollectionTableViewCell.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then

struct MainETCTCollectionTableViewCellModel {
    
    let collectionViewCellModels: [MainETCCollectionViewCellModel]
    
}

final class MainETCTCollectionTableViewCell: UITableViewCell {
    
    typealias CellType = MainETCCollectionViewCell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct ViewConstraint {
        
        static let colums: CGFloat = 2
        static let spacing: CGFloat = 10
        
    }
    
    func configure(_ model: MainETCTCollectionTableViewCellModel) {
        self.items = model.collectionViewCellModels
        
        UIView.performWithoutAnimation {
            self.collectionView.reloadData()
        }
        
        self.layoutSubviews()
        
        let itemWidth = (UIScreen.main.bounds.width - ViewConstraint.spacing * (ViewConstraint.colums - 1)) / ViewConstraint.colums
        let height = itemWidth * CGFloat(self.items.count / 2)
        
        self.collectionView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
        }
        self.collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.registerCell(cell: CellType.self)
            $0.backgroundColor = .clear
            $0.collectionViewLayout = flowLayout
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    private var items: [MainETCCollectionViewCellModel] = []
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
}

extension MainETCTCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Do Something
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - ViewConstraint.spacing * (ViewConstraint.colums - 1)) / ViewConstraint.colums
        return CGSize(width: floor(width), height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ViewConstraint.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ViewConstraint.spacing
    }
    
}

extension MainETCTCollectionTableViewCell: UICollectionViewDataSource {
    
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
