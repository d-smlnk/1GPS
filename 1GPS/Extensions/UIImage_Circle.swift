//
//  UIImage_Circle.swift
//  1GPS
//
//  Created by Дима Самойленко on 09.02.2024.
//

import Foundation
import UIKit

extension UIImage {
    static func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter, height: diameter))
        return renderer.image { context in
            let circle = CGRect(x: 0, y: 0, width: diameter, height: diameter)
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fillEllipse(in: circle)
        }
    }
}

