//
//  MapsVC.swift
//  1GPS
//
//  Created by Дима Самойленко on 05.02.2024.
//  S326288S238561
//  S124291S426047

import UIKit
import GoogleMaps
import CoreLocation

class MapsVC: UIViewController {
    
    //MARK: - DELEGATED API STRING
    
    static var receivedApi: String?
    
    //MARK: - TRACKER MODEL ARRAY FOR API
    
    private var trackerData: [TrackerModel]?
    
    // MARK: - VARIABLES
    
    private var id: Int?
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    private var tlast: Int?
    private var tvalid: Int?
    private var tarc: Int?
    private var azi: Int?
    private var alt: Int?
    private var csq: Int?
    
    // MARK: - COLOR INFO VIEW INSTANCE
    
    private let colorInfoView = ColorInfoView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosition()
    }
    
    private func setupLayout() {
        guard let trackerData = trackerData else { return }
        
        let options = GMSMapViewOptions()
        options.frame = view.bounds
        
        let mapView = GMSMapView(options: options)
        view.addSubview(mapView)
        
        var coordinates = [(latitude: Double, longitude: Double)]()
        
        for trackerModel in trackerData {

            if let latitude = Double(trackerModel.lat ?? String()), let longitude = Double(trackerModel.lng ?? String()) {
                
                let coordinate = (latitude / 1000000, longitude / 1000000)
                coordinates.append(coordinate)
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: coordinate.0, longitude: coordinate.1)
                marker.title = "ID: \(trackerModel.id ?? "")"
                marker.map = mapView
                
                if let csq = Int(trackerModel.csq ?? String()) {
                    switch csq {
                    case 0...10:
                        let markerIcon = UIImage.circle(diameter: 20, color: UIColor(hex: 0xD04848) ?? UIColor())
                        marker.icon = markerIcon
                    case 11...20:
                        let markerIcon = UIImage.circle(diameter: 20, color: UIColor(hex: 0xF8DE22) ?? UIColor())
                        marker.icon = markerIcon
                    case 21...31:
                        let markerIcon = UIImage.circle(diameter: 20, color: .green)
                        marker.icon = markerIcon
                    default:
                        let markerIcon = UIImage.circle(diameter: 20, color: .gray)
                        marker.icon = markerIcon
                    }
                }
            }
        }
        
        let cameraBox = findCameraBox(for: coordinates)
        
        let camera = GMSCameraPosition(latitude: cameraBox.0, longitude: cameraBox.1, zoom: 5)
        mapView.camera = camera
        
        mapView.addSubview(colorInfoView)
        
        //MARK: - CONSTRAINTS
        
        colorInfoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(DS.Paddings.padding)
        }
    
    }

    
    private func findCameraBox(for coordinates: [(latitude: Double, longitude: Double)]) -> (Double, Double) {
        if !coordinates.isEmpty && coordinates.count > 1 {
            
            var minLatitude = coordinates[0].latitude
            var maxLatitude = coordinates[0].latitude
            
            var minLongitude = coordinates[0].longitude
            var maxLongitude = coordinates[0].longitude
            
            var centerLatitude = Double()
            var centerLongitude = Double()
            
            for coordinate in coordinates {
                minLatitude = min(minLatitude, coordinate.latitude)
                maxLatitude = max(maxLatitude, coordinate.latitude)
                minLongitude = min(minLongitude, coordinate.longitude)
                maxLongitude = max(maxLongitude, coordinate.longitude)
                
                centerLatitude = (minLatitude + maxLatitude) / 2
                centerLongitude = (minLongitude + maxLongitude) / 2
            }
            
            return (centerLatitude, centerLongitude)
        } else {
            
            guard let latitude = coordinates.first?.latitude else { return (0, 0) }
            guard let longitude = coordinates.first?.longitude else { return (0, 0) }
            
            return (latitude, longitude)
        }
    }
    
    //MARK: API COMPLETION HANDLER
    
    private func fetchPosition() {
        guard let receivedApi = MapsVC.receivedApi else { return }
        let parameters = ParamsBuilder(apiKey: receivedApi, trackerID: 0, functionCode: 1)
        
        let trackData = TrackDatasource(parameters: parameters)
        
        trackData.fetchTrackData { response in
            switch response {
            case .success(let trackerData):
                trackerData.forEach { trackerModel in
                    
                    guard let latitude = trackerModel.lat,
                          let longitude = trackerModel.lng,
                          let id = trackerModel.id,
                          let tlast = trackerModel.tlast,
                          let tvalid = trackerModel.tvalid,
                          let tarc = trackerModel.tarc,
                          let azi = trackerModel.azi,
                          let alt = trackerModel.alt,
                          let csq = trackerModel.csq
                    else { return }
                    
                    self.id = Int(id)
                    self.tlast = Int(tlast)
                    self.tvalid = Int(tvalid)
                    self.tarc = Int(tarc)
                    self.azi = Int(azi)
                    self.alt = Int(alt)
                    self.trackerData = trackerData
                    self.latitude = CLLocationDegrees(latitude)
                    self.longitude = CLLocationDegrees(longitude)
                    self.csq = Int(csq)
                }
                
                self.setupLayout()

            case .failure(let error):
                print(error)
            }
        }
    }
}
