//
//  CustomAlertView.swift
//  1GPS
//
//  Created by Дима Самойленко on 04.02.2024.
//

import Foundation
import UIKit
import SwiftMessages

class CustomAlertView: UIView {
    let theme: Theme
    let text: String
    
    init(theme: Theme, text: String) {
        self.theme = theme
        self.text = text
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLayout() {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureDropShadow()
        guard let iconText = ["🤔", "😳", "🙄", "😶"].randomElement() else { return }
        view.configureContent(title: "Error", body: text, iconText: iconText)
        view.button?.isHidden = true

        
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = DS.SizeOFElements.customCornerRadius
        
        SwiftMessages.show(view: view)
    }
}
