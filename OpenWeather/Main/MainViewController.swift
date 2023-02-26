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
import ReactorKit
import RxDataSources

final class MainViewController: UIViewController, View {
    
    typealias Reactor = MainViewReactor
    
    init(reactor: MainViewReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMainView()
    }
    
    func bind(reactor: MainViewReactor) {
        // Action
        LocationManager.shared.currentLocation
            .map { Reactor.Action.updateLocation(location: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.mainView.searchTextField.rx.textFieldDidTap
            .map { reactor.reactorForSearch() }
            .withUnretained(self)
            .subscribe(onNext: { viewController, reactor in
                let serachViewController = SearchViewController(reactor: reactor)
                serachViewController.modalPresentationStyle = .popover
                viewController.present(serachViewController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        self.mainView.tableView.rx
            .scrollViewWillBeginDecelerating
            .subscribe(onNext: {
                let translationY = $0.panGestureRecognizer.translation(in: $0.superview).y
                if translationY > 0 {
                    self.mainView.showSearchView()
                } else if translationY < 0  {
                    self.mainView.hideSearchView()
                }
            })
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.sections }
        .bind(to: self.mainView.tableView.rx.items(dataSource: self.dataSource))
        .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.currentWeather }
        .withUnretained(self.mainView)
        .subscribe(onNext: { view, weather in view.updateCurrentWeather(weather: weather) })
        .disposed(by: self.disposeBag)
        
        
        // View
        self.mainView.tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
    
    private func setupMainView() {
        self.view.addSubview(self.mainView)
        self.mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<MainSection>(configureCell: { _, tableView, indexPath, item in
        switch item {
        case .header(let model):
            guard let cell = tableView.dequeueReusableCell(cell: MainHeaderTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(model)
            return cell
            
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
    })
    
    private let mainView = MainView(frame: .zero)
    var disposeBag = DisposeBag()
    
}

extension MainViewController: UITableViewDelegate { }
