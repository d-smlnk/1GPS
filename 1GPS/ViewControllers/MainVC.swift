//
//  MainVC.swift
//  1GPS
//
//  Created by Дима Самойленко on 04.02.2024.
//

import UIKit
import SnapKit
import Lottie

class MainVC: UIViewController {

    //MARK: - VARIABLES
    
    private var apiKeyTF: UITextField!
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTap()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismissKeyboardOnTap()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = DS.Colors.mainColor
        
        let earthIV = UIImageView(image: DS.Images.earthImage)
        view.addSubview(earthIV)
        
        let actionLabel = UILabel()
        actionLabel.text = "Insert your API key"
        actionLabel.font = DS.Fonts.smallTitleFont
        
        apiKeyTF = UITextField(image: DS.Images.apiKeyImage, placeholder: "Example: S326288S238561", contentType: .default, addBtn: true)
        apiKeyTF.backgroundColor = DS.Colors.additionalColor
        apiKeyTF.layer.cornerRadius = DS.SizeOFElements.customCornerRadius
        
        let apiKeySV = UIStackView(arrangedSubviews: [actionLabel, apiKeyTF])
        apiKeySV.axis = .vertical
        apiKeySV.distribution = .fillEqually
        apiKeySV.spacing = CGFloat(DS.Paddings.spacing)
        view.addSubview(apiKeySV)
        
        let sendApiKeyBtn = UIButton()
        sendApiKeyBtn.setTitle("Next", for: .normal)
        sendApiKeyBtn.setTitleColor(DS.Colors.additionalColor, for: .normal)
        sendApiKeyBtn.titleLabel?.font = DS.Fonts.smallTitleFont
        sendApiKeyBtn.layer.cornerRadius = DS.SizeOFElements.customCornerRadius
        sendApiKeyBtn.backgroundColor = DS.Colors.borderColor
        sendApiKeyBtn.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        view.addSubview(sendApiKeyBtn)
        
        //MARK: - CONSTRAINTS
        
        earthIV.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(DS.Paddings.padding * 2)
            $0.width.equalTo(earthIV.snp.height)
        }
        
        apiKeySV.snp.makeConstraints {
            $0.top.equalTo(earthIV.snp.bottom).offset(DS.Paddings.spacing)
            $0.horizontalEdges.equalToSuperview().inset(DS.Paddings.padding)
        }
        
        sendApiKeyBtn.snp.makeConstraints {
            $0.top.equalTo(apiKeySV.snp.bottom).offset(DS.Paddings.largeSpacing)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(view.frame.width - (view.frame.width / 3))
            $0.height.equalTo(DS.SizeOFElements.heightForSingleElements)
        }

    }
    
    //MARK: - ANIMATION
    
    private func launchScreen() {
        let animationBackgroundView = UIView()
        animationBackgroundView.backgroundColor = DS.Colors.additionalColor2
        view.addSubview(animationBackgroundView)
        
        navigationItem.hidesBackButton = true
        
        animationView = .init(name: "loader")
        
        guard let animationView = animationView else { return }
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 0.5
        animationBackgroundView.addSubview(animationView)
        
        animationView.play()
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            animationView.pause()
            animationBackgroundView.removeFromSuperview()
            
            let mainTabBarController = MainTabBarController()
            self.navigationController?.pushViewController(mainTabBarController, animated: true)
        }
    
        //MARK: - CONSTRAINTS OF ANIMATIONS
        
        animationBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//MARK: - @objc METHODS

extension MainVC {
    
    @objc private func nextVC() {
        if apiKeyTF.text?.count ?? 0 == 14 {
            MenuVC.receivedApi = apiKeyTF.text
            MapsVC.receivedApi = apiKeyTF.text
            TrackerListVC.receivedApi = apiKeyTF.text
            
            if let api = apiKeyTF.text {
                let parameters = ParamsBuilder(apiKey: api)
                let tracker = TrackDatasource(parameters: parameters)
                
                tracker.fetchTrackData { responce in
                    switch responce {
                    case .success(let trackerModel):
                        self.launchScreen()
                    case.failure(let error):
                        _ = CustomAlertView(theme: .error, text: "Check your API Key")
                    }
                }
            }
            
        } else {
            _ = CustomAlertView(theme: .error, text: "The API Key must consist of 14 characters")
            
        }
    }
}
