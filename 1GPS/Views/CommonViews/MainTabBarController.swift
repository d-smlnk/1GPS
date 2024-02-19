//
//  MainTabBarController.swift
//  1GPS
//
//  Created by Дима Самойленко on 04.02.2024.
//

import Foundation
import UIKit
import Lottie

class MainTabBarController: UITabBarController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(vc: TrackerListVC(), title: "List", image: DS.Images.trackerList),
            generateVC(vc: MapsVC(), title: "Map", image: DS.Images.mapIcon),
            generateVC(vc: MenuVC(), title: "Menu", image: DS.Images.menuIcon),
            generateVC(vc: RouteTempVC(), title: "Track", image: DS.Images.temporaryRouteIcon),
            generateVC(vc: SimCardVC(), title: "SIM", image: DS.Images.simCard)
        ]
        
        self.selectedIndex = 1
        navigationItem.hidesBackButton = true
    }
    
    private func generateVC(vc : UIViewController, title: String, image: UIImage?) -> UIViewController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image?.resized(to: CGSize(width: 30, height: 30))

        return vc
    }
    
    private func setTabBarAppearance() {
        let appearance = tabBar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.backgroundEffect = nil
        appearance.backgroundColor = .clear
        tabBar.standardAppearance = appearance
        
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        var bezierPath = UIBezierPath()
        
        if UIScreen.main.bounds.width < 393 && UIScreen.main.bounds.height < 852 {
            bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: tabBar.bounds.minY - positionOnY, width: tabBar.bounds.width, height: height),
                                      byRoundingCorners: [.topLeft, .topRight],
                                      cornerRadii: CGSize(width: width, height: height))
            
        } else {
            bezierPath = UIBezierPath(roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minY - positionOnY, width: width, height: height), cornerRadius: height / 2)
        }
        
        roundLayer.path = bezierPath.cgPath
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = DS.Colors.secondaryColor?.cgColor
        tabBar.tintColor = DS.Colors.mainColor
        tabBar.unselectedItemTintColor = DS.Colors.borderColor
        
        
        let logOutBtn = UIButton(type: .custom)
        logOutBtn.setImage(DS.Images.logoutImage, for: .normal)
        logOutBtn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        let logoutBarButtonItem = UIBarButtonItem(customView: logOutBtn)
        
        navigationItem.rightBarButtonItem = logoutBarButtonItem
        navigationItem.hidesBackButton = true
        
        //MARK: CONSTRAINTS
        
        logOutBtn.snp.makeConstraints {
            $0.size.equalTo(DS.SizeOFElements.heightForSingleElements)
        }
    }
}

//MARK: @objc METHODS

extension MainTabBarController {
   @objc private func logout() {
       if let navigationController = self.navigationController {
           navigationController.popToRootViewController(animated: true)
       }
   }
}

