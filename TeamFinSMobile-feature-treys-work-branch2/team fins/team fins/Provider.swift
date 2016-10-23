//
//  Provider.swift
//  team fins
//
//  Created by Trey Baugher on 10/22/16.
//  Copyright © 2016 Team Fins. All rights reserved.
//

import UIKit
import Alamofire

struct Provider {
    let uid: Int
    let phoneNumber: String
    let locationName: String
    let generalDescription: String
    let totalBeds: Int
    let occupiedBeds: Int
    let intakeStart: Int
    let intakeEnd: Int
    let acceptedClients: AcceptedClients
    let address: Address
    let gpsLocation: GpsLocation
    
    init(fromJSON: JSON) {
        uid = fromJSON["uid"].int ?? 0
        phoneNumber = fromJSON["phone"].string ?? ""
        locationName = fromJSON["location"].string ?? ""
        generalDescription = fromJSON["description"].string ?? ""
        totalBeds = fromJSON["totalBeds"].int ?? 0
        occupiedBeds = fromJSON["occupiedBeds"].int ?? 0
        intakeStart = fromJSON["intakeStart"].int ?? 0
        intakeEnd = fromJSON["intakeEnd"].int ?? 0
        acceptedClients = AcceptedClients.init(fromJSON: fromJSON["acceptedClients"])
        address = Address.init(fromJSON: fromJSON["address"])
        gpsLocation = GpsLocation.init(fromJSON: fromJSON["gpsLocation"])
    }
    
}

struct AcceptedClients {
    let men: Bool
    let women: Bool
    let children: Bool
    let veterans: Bool
    let disabled: Bool
    
    init(fromJSON: JSON) {
        men = fromJSON["men"].bool ?? false
        women = fromJSON["women"].bool ?? false
        children = fromJSON["children"].bool ?? false
        veterans = fromJSON["veterans"].bool ?? false
        disabled = fromJSON["disabled"].bool ?? false
    }
    
    init(men: Bool, women: Bool, children: Bool, veterans: Bool, disabled: Bool) {
        self.men = men
        self.women = women
        self.children = children
        self.veterans = veterans
        self.disabled = disabled
    }
}

struct Address {
    let line1: String
    let line2: String?
    let city: String
    let state: String
    let zip: Int
    
    init(fromJSON: JSON) {
        line1 = fromJSON["line1"].string ?? ""
        line2 = fromJSON["line2"].string ?? ""
        city = fromJSON["city"].string ?? ""
        state = fromJSON["state"].string ?? ""
        zip = fromJSON["zip"].int ?? 0
    }
    
    init(line1: String, line2: String?, city: String, state: String, zip: Int) {
        self.line1 = line1
        self.line2 = line2
        self.city = city
        self.state = state
        self.zip = zip
    }
}

class ChangedAddress {
    var line1: String?
    var line2: String?
    var city: String?
    var state: String?
    var zip: Int?
    
    init(){}
}

struct GpsLocation {
    let lat: Float
    let long: Float
    
    init(fromJSON: JSON) {
        lat = fromJSON["lat"].float ?? 0.0
        long = fromJSON["long"].float ?? 0.0
    }
    
    init(lat: Float, long: Float) {
        self.lat = lat
        self.long = long
    }
}
