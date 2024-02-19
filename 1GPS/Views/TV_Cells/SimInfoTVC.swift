//
//  SimInfoTVC.swift
//  1GPS
//
//  Created by Дима Самойленко on 19.02.2024.
//

import UIKit

class SimInfoTVC: UITableViewCell {
    
    //MARK: - reuseIdentifier
    
    static let reuseIdentifier = "SimInfoTVC"
    
    //MARK: - Tracker model
    
    var trackerModel: TrackerModel?
    
    //MARK: - INSTANTS
    
    private let nameLbl = UILabel()
    private let idLbl = UILabel()
    private let numLbl = UILabel()
    private let balanceLbl = UILabel()
    
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
        
        [nameLbl, numLbl, balanceLbl].forEach {
            $0.numberOfLines = 0
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.lineBreakMode = .byWordWrapping
        }
        
        let initialsCV = UIStackView(arrangedSubviews: [idLbl, nameLbl])
        initialsCV.distribution = .fillEqually
        initialsCV.axis = .vertical
            
        let simSV = UIStackView(arrangedSubviews: [numLbl, balanceLbl])
        simSV.axis = .vertical
        simSV.distribution = .fillEqually
        
        let commonSV = UIStackView(arrangedSubviews: [initialsCV, simSV])
        commonSV.axis = .horizontal
        commonSV.distribution = .fillEqually
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
        idLbl.text = "ID: \(trackerModel?.id ?? "No ID")"
        nameLbl.text = "Tracker name:\n\(trackerModel?.reserved ?? "No Name")"
        numLbl.text = "SIM Number:\n\(trackerModel?.num ?? "No number")"
        balanceLbl.text = "SIM Balance:\n\(trackerModel?.balance ?? "0")"

    }
    
}
