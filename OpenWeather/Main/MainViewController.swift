//
//  MainViewController.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then

final class MainViewController: UIViewController {
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: MainViewModel
}