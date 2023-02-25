//
//  MainViewController.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class MainViewController: UIViewController {
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupMainView()
        self.bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MainViewModel) {
        viewModel
            .viewModelEvent
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { viewController, event in viewController.handle(event) })
            .disposed(by: self.disposeBag)
    }
    
    private func handle(_ event: MainViewModelEvent) {
        switch event {
        case .reloadData:
            self.mainView.reloadData()
            
        case .showSearchView(let viewModel):
            self.showSearchView(viewModel)
        }
    }
    
    private func showSearchView(_ viewModel: SearchViewModel) {
        let viewController = SearchViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .popover
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func setupMainView() {
        self.view.addSubview(self.mainView)
        self.mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.mainView.delegate = self
        self.mainView.dataSource = self
    }
    
    private let mainView = MainView(frame: .zero)
    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    
}

extension MainViewController: MainViewDelegate {
    
    func commonTextFieldTextFieldDidTap(_ view: CommonTextField) {
        self.viewModel.searchTextFieldDidTap()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.cellDidSelect(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = self.viewModel.headerModel(section) else { return nil }
        return MainHeaderView(frame: .zero).then {
            $0.configure(model)
        }
    }
    
}

extension MainViewController: MainViewDataSource {
    
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
        case .title(let model):
            guard let cell = tableView.dequeueReusableCell(cell: MainTitleTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(model, inset: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
            return cell
            
        case .todayWeather(let model):
            guard let cell = tableView.dequeueReusableCell(cell: MainTodayWeatherCollectionTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(model)
            return cell
            
        case .weather(let model):
            guard let cell = tableView.dequeueReusableCell(cell: MainWeatherTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(model)
            return cell
            
        case .precipitation(let model):
            guard let cell = tableView.dequeueReusableCell(cell: MainPrecipitationTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(model)
            return cell
            
        case .etc(let model):
            guard let cell = tableView.dequeueReusableCell(cell: MainETCTCollectionTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(model)
            return cell
        }
    }
    
}
