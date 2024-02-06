//
//  SimCardVC.swift
//  1GPS
//
//  Created by Дима Самойленко on 05.02.2024.
//

import UIKit

class SimCardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        view.backgroundColor = .red
    }

}
/*
 class MapsVC: UIViewController {
     
     static var receivedApi: String?
     
     private var trackerData: TrackerModel?
     
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
         
         guard let trackerData = trackerData,
               let latitude = CLLocationDegrees(trackerData.lat ?? ""),
               let longitude = CLLocationDegrees(trackerData.lng ?? ""),
               let id = trackerData.id,
               let tlast = trackerData.tlast,
               let tvalid = trackerData.tvalid,
               let tarc = trackerData.tarc,
               let azi = trackerData.azi,
               let alt = trackerData.alt else { return }
         
         let options = GMSMapViewOptions()
         options.camera = GMSCameraPosition.camera(withLatitude: latitude / 1000000, longitude: longitude / 1000000, zoom: 6.0)
         options.frame = self.view.bounds
         
         let mapView = GMSMapView(options: options)
         self.view.addSubview(mapView)
         
         let marker = GMSMarker()
         marker.position = CLLocationCoordinate2D(latitude: latitude / 1000000, longitude: 35.461703)
         marker.map = mapView
     }
     
     private func fetchPosition() {
         guard let receivedApi = MapsVC.receivedApi else { return }
         let parameters = ParamsBuilder(apiKey: receivedApi, trackerID: 0, functionCode: 1, startTimeUNIX: 1508738400, endTimeUNIX: 1508770800)
         
         let trackData = TrackDatasource(parameters: parameters)
         
         trackData.fetchTrackData { response in
             switch response {
             case .success(let trackerData):
                 guard let latitude = trackerData.lat,
                       let longitude = trackerData.lng,
                       let id = trackerData.id,
                       let tlast = trackerData.tlast,
                       let tvalid = trackerData.tvalid,
                       let tarc = trackerData.tarc,
                       let azi = trackerData.azi,
                       let alt = trackerData.alt else { return }
                 
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

             case .failure(let error):
                 print(error)
             }
         }
     }
 }

 */
