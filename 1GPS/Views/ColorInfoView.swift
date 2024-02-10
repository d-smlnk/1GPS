//
//  ColorInfoView.swift
//  1GPS
//
//  Created by Дима Самойленко on 09.02.2024.
//

import Foundation
import UIKit

class ColorInfoView: UIView {
    
    private let screenSize = UIScreen.main.bounds.size
    private var labels = [UILabel]()
    private var colorSV = UIStackView()
    private let chevronBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        self.backgroundColor = DS.Colors.secondaryColor
        self.layer.cornerRadius = DS.SizeOFElements.customCornerRadius
        
        let colorArray = [
            (UIImageView(), UIImage.circle(diameter: 25, color: UIColor(hex: 0xD04848) ?? UIColor()), "Good GSM signal"),
            (UIImageView(), UIImage.circle(diameter: 25, color: UIColor(hex: 0xF8DE22) ?? UIColor()), "Average GSM signal"),
            (UIImageView(), UIImage.circle(diameter: 25, color: .green), "Bad GSM signal"),
            (UIImageView(), UIImage.circle(diameter: 25, color: .gray), "No GSM signal")
        ]
        
        
            colorSV = UIStackView(arrangedSubviews: colorArray.map { imageView, circleImage, text in
            let customView = UIView()
            
            imageView.image = circleImage
            imageView.contentMode = .scaleAspectFit
            
            let label = UILabel()
            label.text = text
            label.isHidden = true
            
            labels.append(label)
            
            [imageView, label].forEach {
                customView.addSubview($0)
            }
            
            imageView.snp.makeConstraints {
                $0.top.bottom.leading.equalToSuperview().inset(DS.Paddings.spacing)
            }
            
            label.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalTo(imageView.snp.trailing).offset(DS.Paddings.spacing)
            }
            
            return customView
        })
        
        colorSV.axis = .vertical
        colorSV.distribution = .fillEqually
        self.addSubview(colorSV)
        
        chevronBtn.setImage(DS.Images.chevronOpen, for: .normal)
        chevronBtn.addTarget(self, action: #selector(openColorView), for: .touchUpInside)
        self.addSubview(chevronBtn)
        
        // MARK: - CONSTRAINTS
        #warning("fix chevron constr when view is open")
                
        self.snp.makeConstraints {
            $0.width.equalTo(screenSize.width / 6)
        }
        
        colorSV.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
            $0.trailing.equalTo(chevronBtn.snp.leading).offset(-DS.Paddings.spacing)
        }
        
        chevronBtn.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.size.equalTo(30)
            $0.leading.equalTo(colorSV.snp.trailing)
        }
    }
}

//MARK: - @objc METHODS

extension ColorInfoView {
    @objc private func openColorView(_ btn: UIButton) {
        btn.isSelected.toggle()
        if btn.isSelected {
            btn.setImage(DS.Images.chevronClose, for: .normal)
            
            labels.forEach { $0.isHidden = false }
            
            self.snp.updateConstraints {
                $0.width.equalTo(self.screenSize.width / 1.7)
            }
            
        } else {
            btn.setImage(DS.Images.chevronOpen, for: .normal)
            
            labels.forEach { $0.isHidden = true }
            
            self.snp.updateConstraints {
                $0.width.equalTo(self.screenSize.width / 6)
            }
    
        }
    }
}
