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
    
    static var receivedApi: String?
    
    private var trackerData: [TrackerModel]?
    
    private var id: Int?
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    private var tlast: Int?
    private var tvalid: Int?
    private var tarc: Int?
    private var azi: Int?
    private var alt: Int?
    
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

            if let latitude = Double(trackerModel.lat!), let longitude = Double(trackerModel.lng!) {
                
                let coordinate = (latitude / 1000000, longitude / 1000000)
                coordinates.append(coordinate)
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: coordinate.0, longitude: coordinate.1)
                marker.title = "ID: \(trackerModel.id ?? "")"
                marker.icon = GMSMarker.markerImage(with: .blue)
                marker.map = mapView
            }
        }
        
        let cameraBox = findCameraBox(for: coordinates)
        
        let camera = GMSCameraPosition(latitude: cameraBox.0, longitude: cameraBox.1, zoom: 5)
        mapView.camera = camera
    
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
                          let alt = trackerModel.alt else { return }
                    
                    self.id = Int(id)
                    self.tlast = Int(tlast)
                    self.tvalid = Int(tvalid)
                    self.tarc = Int(tarc)
                    self.azi = Int(azi)
                    self.alt = Int(alt)
                    self.trackerData = trackerData
                    self.latitude = CLLocationDegrees(latitude)
                    self.longitude = CLLocationDegrees(longitude)
                    
                    self.setupLayout()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
