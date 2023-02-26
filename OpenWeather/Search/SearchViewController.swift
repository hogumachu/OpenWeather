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
import RxCocoa
import ReactorKit
import RxDataSources

protocol SearchViewControllerDelegate: AnyObject {
    
    func searchViewControllerDidSearch(_ viewController: SearchViewController, location: Location)
    
}

final class SearchViewController: UIViewController, View {
    
    weak var delegate: SearchViewControllerDelegate?
    
    typealias Reactor = SearchViewReactor
    
    init(reactor: SearchViewReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchView()
    }
    
    func bind(reactor: SearchViewReactor) {
        // Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.searchView.tableView.rx.itemSelected
            .map { Reactor.Action.itemSelectAt(indexPath: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.searchView.searchTextField.rx.textFieldUpdateText
            .distinctUntilChanged()
            .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .map { Reactor.Action.textUpdate(keyword: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.currentLocation }
        .withUnretained(self)
        .subscribe(onNext: { viewController, location in viewController.dismissWithLocationIfEnabled(location) })
        .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections }
        .bind(to: self.searchView.tableView.rx.items(dataSource: self.dataSource))
        .disposed(by: self.disposeBag)
        
        // View
        self.searchView.tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
    
    private func dismissWithLocationIfEnabled(_ location: Location?) {
        guard let location = location else { return }
        self.dismiss(animated: true) {
            self.delegate?.searchViewControllerDidSearch(self, location: location)
        }
    }
    
    private func setupSearchView() {
        self.view.addSubview(self.searchView)
        self.searchView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<SearchSection>(configureCell: { _, tableView, indexPath, item in
        switch item {
        case .search(let model, _):
            guard let cell = tableView.dequeueReusableCell(cell: SearchTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(model)
            return cell
        }
    })
    
    private let searchView = SearchView(frame: .zero)
    var disposeBag = DisposeBag()
    
}

extension SearchViewController: UITableViewDelegate { }
