//
//  MapsVC.swift
//  1GPS
//
//  Created by Дима Самойленко on 05.02.2024.
//  S326288S238561

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
        options.frame = self.view.bounds
        let mapView = GMSMapView(options: options)
        self.view.addSubview(mapView)
        
        var coordinates = [(latitude: Double, longitude: Double)]()
        
        for trackerModel in trackerData {

            if let latitude = trackerModel.lat, let longitude = trackerModel.lng {
                let coordinate = (Double(latitude) ?? 0 / 1000000, Double(longitude) ?? 0 / 1000000)
                coordinates.append(coordinate)
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: coordinate.0, longitude: coordinate.1)
                marker.title = "ID: \(trackerModel.id ?? "")"
                marker.icon = GMSMarker.markerImage(with: .blue)
                marker.map = mapView
            }
        }
        
        if let boundingBox = findBoundingBox(for: coordinates) {
            
            let centerLatitude = (boundingBox.minLatitude + boundingBox.maxLatitude) / 2
            let centerLongitude = (boundingBox.minLongitude + boundingBox.maxLongitude) / 2
            
            let latitudeDelta = boundingBox.maxLatitude - boundingBox.minLatitude
            let longitudeDelta = boundingBox.maxLongitude - boundingBox.minLongitude
            
            let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: boundingBox.maxLatitude, longitude: boundingBox.minLongitude),
                                              coordinate: CLLocationCoordinate2D(latitude: boundingBox.minLatitude, longitude: boundingBox.maxLongitude))
            
            let camera = mapView.camera(for: bounds, insets: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
            mapView.camera = camera ?? GMSCameraPosition.camera(withLatitude: centerLatitude, longitude: centerLongitude, zoom: 6.0)
        }
    }

    
    private func findBoundingBox(for coordinates: [(latitude: Double, longitude: Double)]) -> (minLatitude: Double, maxLatitude: Double, minLongitude: Double, maxLongitude: Double)? {
        guard !coordinates.isEmpty else { return nil }
        
        var minLatitude = coordinates[0].latitude
        var maxLatitude = coordinates[0].latitude
        var minLongitude = coordinates[0].longitude
        var maxLongitude = coordinates[0].longitude
        
        for coordinate in coordinates {
            minLatitude = min(minLatitude, coordinate.latitude)
            maxLatitude = max(maxLatitude, coordinate.latitude)
            minLongitude = min(minLongitude, coordinate.longitude)
            maxLongitude = max(maxLongitude, coordinate.longitude)
        }
        
        return (minLatitude, maxLatitude, minLongitude, maxLongitude)
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
