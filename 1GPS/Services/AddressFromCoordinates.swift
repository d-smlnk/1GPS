//
//  AddressFromCoordinates.swift
//  1GPS
//
//  Created by Дима Самойленко on 15.02.2024.
//

import Foundation
import UIKit
import CoreLocation

struct AddressFromCoordinates {
    
    let latitude: Double
    let longitude: Double
    
    func getAddressFromCoordinates(completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Reverse geocoding failed with error: \(error?.localizedDescription ?? "")")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found")
                completion(nil)
                return
            }
                        
            var addressString: String = ""
            
            if let city = placemark.locality {
                addressString = addressString + city + ", "
            }
            
            if let street = placemark.thoroughfare {
                addressString = addressString + street + ", "
            }
            
            if let houseNum = placemark.subThoroughfare {
                addressString = addressString + houseNum + ", "
            }
            
            if let country = placemark.country {
                addressString = addressString + country + ", "
            }
            if let postalCode = placemark.postalCode {
                addressString = addressString + postalCode + " "
            }
            completion(addressString)
        }
    }
    
}
