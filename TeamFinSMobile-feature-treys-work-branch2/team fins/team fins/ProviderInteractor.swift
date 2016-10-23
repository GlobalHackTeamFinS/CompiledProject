//
//  ProviderInteractor.swift
//  team fins
//
//  Created by Trey Baugher on 10/22/16.
//  Copyright © 2016 Team Fins. All rights reserved.
//

import Foundation
import CoreLocation

struct ProviderInteractor {
    static func locationFromAddress(address: Address, completion: @escaping (GpsLocation) -> Void) {
        let geocoder = CLGeocoder()
        let addressString = "\(address.line1), \(address.city), \(address.state), United States"
        geocoder.geocodeAddressString(addressString) {
            placemarks, error in
            guard let placemarks = placemarks else { return }
            for placemark in placemarks {
                guard let long = placemark.location?.coordinate.longitude else { continue }
                guard let lat = placemark.location?.coordinate.latitude else { continue }
                let gps = GpsLocation(lat: Float(lat), long: Float(long))
                completion(gps)
            }
        }
    }
}
