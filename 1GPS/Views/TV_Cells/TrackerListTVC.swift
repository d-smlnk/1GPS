//
//  TrackerListTVC.swift
//  1GPS
//
//  Created by Дима Самойленко on 14.02.2024.
//  

import UIKit
import CoreLocation

class TrackerListTVC: UITableViewCell {
    
    //MARK: - reuseIdentifier
    
    static let reuseIdentifier = "TrackerListTVC"
    
    //MARK: - Tracker model
    
    var trackerModel: TrackerModel?
    var trackerNameModel: TrackerModel?
    
    //MARK: - INSTANTS
    
    private let nameLbl = UILabel()
    private let idLbl = UILabel()
    private let addressLbl = UILabel()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP LAYOUT
    
    private func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none

        let customView = UIView()
        customView.backgroundColor = DS.Colors.secondaryColor
        customView.layer.cornerRadius = DS.SizeOFElements.customCornerRadius
        addSubview(customView)
        
        nameLbl.numberOfLines = 0
        nameLbl.setContentHuggingPriority(.required, for: .vertical)
        nameLbl.lineBreakMode = .byWordWrapping
        
        let initialsCV = UIStackView(arrangedSubviews: [idLbl, nameLbl])
        initialsCV.distribution = .fillEqually
        initialsCV.axis = .vertical
        customView.addSubview(initialsCV)

        addressLbl.numberOfLines = 0
        addressLbl.setContentHuggingPriority(.required, for: .vertical)
        addressLbl.lineBreakMode = .byWordWrapping
        
        let commonSV = UIStackView(arrangedSubviews: [initialsCV, addressLbl])
        commonSV.axis = .horizontal
        commonSV.distribution = .fill
        customView.addSubview(commonSV)
        
        //MARK: - CONSTRAINTS
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.height / 8)
            $0.edges.equalToSuperview()
        }
        
        customView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(DS.Paddings.spacing)
        }
        
        commonSV.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(DS.Paddings.spacing)
        }
        
    }
    
    //MARK: - CONFIGURE CELL DATA
    
    func configure() {
        idLbl.text = "ID: \(trackerModel?.id ?? "")"
        nameLbl.text = "Tracker alias:\n \(trackerNameModel?.name ?? "")"
        
        guard let lat = trackerModel?.lat, let lng = trackerModel?.lng else { return }
        
        let addressConverter = AddressFromCoordinates(latitude: (Double(lat) ?? Double()) / 1000000, longitude: (Double(lng) ?? Double()) / 1000000)
        
        addressConverter.getAddressFromCoordinates() { address in
            
            switch address {
            case .some(let address):
                DispatchQueue.main.async {
                    self.addressLbl.text = "Address: \(address)"
                }
            case .none:
                print("Failed to get address")
            }
        }
    }
    
}
