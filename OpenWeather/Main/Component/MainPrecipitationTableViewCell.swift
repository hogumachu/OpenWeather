//
//  MainPrecipitationTableViewCell.swift
//  OpenWeather
//
//  Created by 홍성준 on 2023/02/24.
//

import UIKit
import SnapKit
import Then
import MapKit

struct MainPrecipitationTableViewCellModel {
    
    let lat: Double
    let lon: Double
    
}

final class MainPrecipitationTableViewCell: UITableViewCell, MKMapViewDelegate {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.setupAttirutes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: MainPrecipitationTableViewCellModel) {
        self.moveLocation(lat: model.lat, lon: model.lon)
    }
    
    private func moveLocation(lat: Double, lon: Double) {
        let location = CLLocationCoordinate2DMake(lat, lon)
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: location, span: span)
        let point = MKPointAnnotation().then {
            $0.coordinate = location
        }
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(point)
        self.mapView.setRegion(region, animated: true)
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
        }
        
        self.contentView.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
    }
    
    private func setupAttirutes() {
        self.selectionStyle = .none
        self.backgroundColor = .black.withAlphaComponent(0.2)
        
        self.titleLabel.do {
            $0.text = "강수량"
            $0.textColor = .white.withAlphaComponent(0.7)
            $0.font = .systemFont(ofSize: 13, weight: .regular)
        }
        
        self.mapView.do {
            $0.backgroundColor = .clear
            $0.delegate = self
        }
    }
    
    private let titleLabel = UILabel(frame: .zero)
    private let mapView = MKMapView(frame: .zero)
}
