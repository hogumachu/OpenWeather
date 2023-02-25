//
//  SearchTextField.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/25.
//

import UIKit
import SnapKit
import Then

protocol CommonTextFieldTextFieldDelegate: UITextFieldDelegate {
    
    func commonTextFieldTextFieldDidTap(_ view: CommonTextField)
    func commonTextFieldTextFieldDidUpdateText(_ view: CommonTextField, text: String)
    
}

extension CommonTextFieldTextFieldDelegate {
    
    func commonTextFieldTextFieldDidTap(_ view: CommonTextField) { }
    func commonTextFieldTextFieldDidUpdateText(_ view: CommonTextField, text: String) { }
    
}

final class CommonTextField: UIView {
    
    weak var delegate: CommonTextFieldTextFieldDelegate? {
        didSet { self.textField.delegate = self.delegate }
    }
    
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
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(30)
        }
        
        self.containerView.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        self.containerView.addSubview(self.textField)
        self.textField.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(5)
        }
    }
    
    private func setupAttributes() {
        self.containerView.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .secondaryColor
            $0.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerViewDidTap(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        self.iconImageView.do {
            $0.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .darkGray
        }
        
        self.textField.do {
            $0.isUserInteractionEnabled = false
            $0.backgroundColor = .clear
            $0.placeholder = "Search"
            $0.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)
        }
    }
    
    @objc private func containerViewDidTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.commonTextFieldTextFieldDidTap(self)
    }
    
    @objc private func textFieldDidChangeText(_ textField: UITextField) {
        self.delegate?.commonTextFieldTextFieldDidUpdateText(self, text: textField.text ?? "")
    }
    
    private let containerView = UIView(frame: .zero)
    private let iconImageView = UIImageView(frame: .zero)
    private let textField = UITextField(frame: .zero)
    
}
