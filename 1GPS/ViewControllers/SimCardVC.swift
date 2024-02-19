//
//  SimCardVC.swift
//  1GPS
//
//  Created by Дима Самойленко on 05.02.2024.
//

import UIKit

class SimCardVC: UIViewController {
    
    //MARK: - DELEGATED API STRING
    
    static var receivedApi: String?
    
    //MARK: - TRACKER MODEL ARRAY FOR API

    private var trackerData: [TrackerModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSimList()
    }
    
    private func setupLayout() {
        view.backgroundColor = DS.Colors.mainColor
        
        let trackerTV = UITableView()
        trackerTV.backgroundColor = .clear
        trackerTV.separatorStyle = .none
        trackerTV.showsVerticalScrollIndicator = false
        trackerTV.layer.cornerRadius = DS.SizeOFElements.customCornerRadius
        trackerTV.delegate = self
        trackerTV.dataSource = self
        trackerTV.register(SimInfoTVC.self, forCellReuseIdentifier: SimInfoTVC.reuseIdentifier)
        view.addSubview(trackerTV)
        
        //MARK: CONSTRAINTS
        
        trackerTV.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(DS.Paddings.padding)
        }
    }
    
    private func fetchSimList() {
        guard let receivedApi = TrackerListVC.receivedApi else { return }
        let parameters = ParamsBuilder(apiKey: receivedApi, trackerID: 0, functionCode: 7) // params for sim info fetching
        
        let trackerLocData = TrackDatasource(parameters: parameters)
        
        trackerLocData.fetchTrackData { response in
            switch response {
            case .success(let trackerData):
                trackerData.forEach { trackerModel in
                    self.trackerData = trackerData
                }
                self.setupLayout()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension SimCardVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trackerData = trackerData else { return 0 }
        return trackerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  SimInfoTVC.reuseIdentifier, for: indexPath) as? SimInfoTVC else { return UITableViewCell() }
        cell.trackerModel = trackerData?[indexPath.row]
        cell.configure()
        return cell
    }
}
