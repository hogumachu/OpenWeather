//
//  SearchTextField.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class CommonTextField: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isTextFieldEnabled: Bool {
        get { self.textField.isUserInteractionEnabled }
        set { self.textField.isUserInteractionEnabled = newValue }
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        self.textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        self.textField.resignFirstResponder()
    }
    
    private func setupLayout() {
        self.addSubview(self.containerButton)
        self.containerButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(30)
        }
        
        self.containerButton.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        self.containerButton.addSubview(self.textField)
        self.textField.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(5)
        }
    }
    
    private func setupAttributes() {
        self.containerButton.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .secondaryColor
        }
        
        self.iconImageView.do {
            $0.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .darkGray
        }
        
        self.textField.do {
            $0.backgroundColor = .clear
            $0.placeholder = "Search"
        }
    }
    
    let containerButton = UIButton(frame: .zero)
    let iconImageView = UIImageView(frame: .zero)
    let textField = UITextField(frame: .zero)
    
}

extension Reactive where Base: CommonTextField {
    
    var textFieldDidTap: ControlEvent<Void> {
        let source = base.containerButton.rx.tap
        return ControlEvent(events: source)
    }
    
    var textFieldUpdateText: ControlEvent<String?> {
        let source = base.textField.rx.text
        return ControlEvent(events: source)
    }
    
}
