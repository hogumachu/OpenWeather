//
//  SearchViewController.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class SearchViewController: UIViewController {
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupSearchView()
        self.bind(self.viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ viewModel: SearchViewModel) {
        viewModel
            .viewModelEvent
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { viewController, event in viewController.handle(event) })
            .disposed(by: self.disposeBag)
    }
    
    private func handle(_ event: SearchViewModelEvent) {
        switch event {
        case .reloadData:
            self.searchView.reloadData()
        }
    }
    
    private func setupSearchView() {
        self.view.addSubview(self.searchView)
        self.searchView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.searchView.delegate = self
        self.searchView.dataSource = self
    }
    
    private let searchView = SearchView(frame: .zero)
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    
}

extension SearchViewController: SearchViewDelegate {
    
    func commonTextFieldTextFieldDidUpdateText(_ view: CommonTextField, text: String) {
        self.viewModel.search(keyword: text)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.cellDidSelect(at: indexPath)
    }
    
}

extension SearchViewController: SearchViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.viewModel.item(at: indexPath) else {
            return UITableViewCell()
        }
        
        switch item {
        case .search(let model):
            guard let cell = tableView.dequeueReusableCell(cell: SearchTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(model)
            return cell
        }
    }
    
}
