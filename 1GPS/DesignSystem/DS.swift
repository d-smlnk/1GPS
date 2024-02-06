//
//  DS.swift
//  1GPS
//
//  Created by Дима Самойленко on 04.02.2024.
//

import Foundation
import UIKit

struct DS {
    
    struct Paddings {
        static let padding = 16
        static let spacing = 8
        static let largeSpacing = 25
    }
    
    struct SizeOFElements {
        static let heightForSingleElements = 50
        static let customBorderWidth: CGFloat = 2
        static let customCornerRadius: CGFloat = 10
    }
    
    struct Fonts {
        static let simpleTextFont = UIFont.boldSystemFont(ofSize: 15)
        static let separateTextFont = UIFont.boldSystemFont(ofSize: 17)
        static let smallTitleFont = UIFont.boldSystemFont(ofSize: 20)
        static let titleFont = UIFont.boldSystemFont(ofSize: 25)
    }
    
    struct Images {
        static let apiKeyImage = UIImage(named: "api-key")
        static let earthImage = UIImage(named: "earthIcon")
        static let infoTFImage = UIImage(named: "infoTFBtn")
        static let logoutImage = UIImage(named: "logout")
        // tabbar icons
        static let menuIcon = UIImage(named: "MenuIcon")
        static let trackerList = UIImage(named: "trackerList")
        static let mapIcon = UIImage(named: "mapIcon")
        static let temporaryRouteIcon = UIImage(named: "temporaryRouteIcon")
        static let simCard = UIImage(named: "simCard")
    }
    
    struct Colors {
        static let mainColor = UIColor(hex: 0x40A2E3)
        static let secondaryColor = UIColor(hex: 0xFFF6E9)
        static let additionalColor = UIColor(hex: 0xBBE2EC)
        static let additionalColor2 = UIColor(hex: 0x98c8d1)
        static let borderColor = UIColor(hex: 0x324A5E)
    }
}
