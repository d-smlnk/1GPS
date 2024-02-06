//
//  UITextField+Image.swift
//  1GPS
//
//  Created by Дима Самойленко on 04.02.2024.
//

import Foundation
import UIKit

extension UITextField {
    
    convenience init(image: UIImage?, placeholder: String?, contentType: UIKeyboardType, addBtn: Bool? = nil) {
        self.init()
        
        // mainview setup
        self.backgroundColor = DS.Colors.secondaryColor
        self.layer.cornerRadius = DS.SizeOFElements.customCornerRadius
        self.autocapitalizationType = .sentences
        self.keyboardType = contentType
        
        let mainViewPadding = UIView()
        self.leftView = mainViewPadding
        self.leftViewMode = .always
        
        // image setup
        let leftImageView = UIImageView()
        leftImageView.image = image
        mainViewPadding.addSubview(leftImageView)
        
        // placeholder setup
        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.firstLineHeadIndent = padding.left
        let attributes: [NSAttributedString.Key: Any] = [
            .font: DS.Fonts.simpleTextFont,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
        self.attributedPlaceholder = attributedPlaceholder
        
        if addBtn ?? true {
            let view = UIView()
            
            let button = UIButton()
            button.setImage(DS.Images.infoTFImage, for: .normal)
            
            self.rightView = view
            self.rightViewMode = .always
            view.addSubview(button)
            
            self.rightView?.snp.makeConstraints {
                $0.size.equalTo(50)
            }
            
            button.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(4)
            }
        }
        
        // MARK: CONSTRAINTS
        
        mainViewPadding.snp.makeConstraints {
            $0.height.width.equalTo(DS.SizeOFElements.heightForSingleElements)
        }
        
        leftImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(DS.SizeOFElements.heightForSingleElements)
        }
    }
}
