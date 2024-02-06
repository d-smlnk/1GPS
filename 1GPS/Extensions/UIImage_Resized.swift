//
//  UIImage_Resized.swift
//  1GPS
//
//  Created by Дима Самойленко on 05.02.2024.
//

import Foundation
import UIKit

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
