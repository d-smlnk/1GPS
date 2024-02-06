//
//  MenuVC.swift
//  1GPS
//
//  Created by Дима Самойленко on 04.02.2024.
//

import UIKit
import SwiftMessages
import Lottie

class MenuVC: UIViewController {
    
    static var receivedApi: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = DS.Colors.additionalColor2
        print(MenuVC.receivedApi)

        //        MARK: CONSTRAINTS
        
        
    }
}

// MARK: @objc METHODS

