//
//  UIViewController_DissmissKeyboard.swift
//  1GPS
//
//  Created by Дима Самойленко on 04.02.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
