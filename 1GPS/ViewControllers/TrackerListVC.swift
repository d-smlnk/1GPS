//
//  TrackerListVC.swift
//  1GPS
//
//  Created by Дима Самойленко on 05.02.2024.
//  S326288S238561

import UIKit
import CoreLocation

class TrackerListVC: UIViewController {
    
    //MARK: - DELEGATED API STRING
    
    static var receivedApi: String?
    
    //MARK: - TRACKER MODEL ARRAY FOR API
    
    private var trackerLocationData: [TrackerModel]?
    private var trackerNameData: [TrackerModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTrackerlist()
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
        trackerTV.register(TrackerListTVC.self, forCellReuseIdentifier: TrackerListTVC.reuseIdentifier)
        view.addSubview(trackerTV)
        
        //MARK: CONSTRAINTS
        
        trackerTV.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(DS.Paddings.padding)
        }
        
    }
    
    private func fetchTrackerlist() {
        guard let receivedApi = TrackerListVC.receivedApi else { return }
        let locationParameters = ParamsBuilder(apiKey: receivedApi, trackerID: 0, functionCode: 1) // params for location fetching
        
        let trackerLocData = TrackDatasource(parameters: locationParameters)
        
        trackerLocData.fetchTrackData { response in
            switch response {
            case .success(let trackerData):
                trackerData.forEach { trackerModel in
                    self.trackerLocationData = trackerData
                }
                self.fetchTrackName()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchTrackName() {
        guard let receivedApi = TrackerListVC.receivedApi else { return }
        
        let nameParameters = ParamsBuilder(apiKey: receivedApi, trackerID: 0, functionCode: 0 ) // params for name fetching
        
        let trackerNameData = TrackDatasource(parameters: nameParameters)
        
        trackerNameData.fetchTrackData { response in
            switch response {
            case .success(let trackerNameData):
                trackerNameData.forEach { trackerModel in
                    self.trackerNameData = trackerNameData
                }
                self.setupLayout()

            case .failure(let error):
                print(error)
            }
        }
        
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension TrackerListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trackerData = trackerLocationData else { return 0 }
        return trackerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerListTVC.reuseIdentifier, for: indexPath) as? TrackerListTVC else { return UITableViewCell() }
        cell.trackerModel = trackerLocationData?[indexPath.row]
        cell.trackerNameModel = trackerNameData?[indexPath.row]
        cell.configure()
        return cell
    }
    
}
