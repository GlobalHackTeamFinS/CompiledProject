//
//  RemoteService.swift
//  team fins
//
//  Created by Trey Baugher on 10/22/16.
//  Copyright © 2016 Team Fins. All rights reserved.
//

import Foundation
import Alamofire

struct RemoteServiceManager {
    
    /*
     app.get('/', homeController.index);
     app.post('/provider/new', providerController.newProvider);
     app.put('/provider/:id', authenticate, providerController.updateProvider);
     // app.delete('/provider/:id', providerController.deleteProvider);
     app.post('/provider/login', providerController.login);
     app.post('/provider/logout', providerController.logout);
     app.post('/provider/:id/increment', authenticate, providerController.increment);
     app.post('/provider/:id/decrement', authenticate, providerController.decrement);
     app.post('/provider/:id/setBase', providerController.setBase);
    */
    
    static func authenticateUser(username: String, password: String, withProvider: @escaping (Provider?) -> Void) {
        let authenticationUrl = "\(RemoteServiceManager.baseURL())/provider/login"
        //app.post('/provider/login', providerController.login);
        let parameters: Parameters = [
            "email": username,
            "password": password
        ]
        
        Alamofire.request(authenticationUrl, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let token = json["token"].string {
                    RemoteServiceManager.storeAuthenticationToken(token: token)
                }
                let provider = Provider(fromJSON: json)
                withProvider(provider)
            case .failure(let error):
                print(error)
                withProvider(nil)
            }
        }
        
        DispatchQueue.main.async {
            
        }
    }
    
    static func createUser(username: String, password: String, forProvider: @escaping (Provider?) -> Void) {
        let createUrl =  "\(RemoteServiceManager.baseURL())/provider/new"
        
        let parameters: Parameters = [
            "email": username,
            "password": password
        ]
        
        Alamofire.request(createUrl, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let token = json["token"].string {
                    RemoteServiceManager.storeAuthenticationToken(token: token)
                }
                let provider = Provider(fromJSON: json)
                forProvider(provider)
            case .failure(let error):
                print(error)
                forProvider(nil)
            }
        }
    }
    
    static func incrementOccupancyFor(providerId: String, completion: @escaping (Bool) -> Void) {
        let occupancyUrl = "\(RemoteServiceManager.baseURL())/provider/\(providerId)/increment"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(RemoteServiceManager.retrieveToken() ?? "")"
        ]
        
        Alamofire.request(occupancyUrl, headers: headers).response { response in
            if ((response.error) != nil) {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    static func decrementOccupancyFor(providerId: String, completion: @escaping (Bool) -> Void) {
        let occupancyUrl = "\(RemoteServiceManager.baseURL())/provider/\(providerId)/decrement"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(RemoteServiceManager.retrieveToken() ?? "")"
        ]
        
        Alamofire.request(occupancyUrl, headers: headers).response { response in
            if (response.error != nil) {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    static func updateProviderFor(providerId:String, phoneNumber: String?, locationName: String?, description: String?, totalBeds: Int?, occupiedBeds: Int?, intakeStart: Int?, intakeEnd: Int?, addressObject:Address?, geoLocation: GpsLocation?, clients: AcceptedClients?, completion: @escaping (Provider?) -> Void) {
        let updateUrl = "\(RemoteServiceManager.baseURL())/provider/\(providerId)";
        var parameters: Parameters = [:]
        if let phone = phoneNumber {
            parameters["phone"] = phone
        }
        if let location = locationName {
            parameters["locationName"] = location
        }
        if let descriptionString = description {
            parameters["description"] = descriptionString
        }
        if let tBedsInt = totalBeds {
            parameters["totalBeds"] = tBedsInt
        }
        if let oBedsInt = occupiedBeds {
            parameters["occupiedBeds"] = oBedsInt
        }
        if let iStart = intakeStart {
            parameters["intakeStart"] = iStart
        }
        if let iEnd = intakeEnd {
            parameters["intakeEnd"] = iEnd
        }
        if let address = addressObject {
            
            let addressParameters: Parameters = [
                "line1" : address.line1,
                "line2" : address.line2,
                "city" : address.city,
                "state" : address.state,
                "zip" : address.zip
            ]
            parameters["address"] = addressParameters
        }
        
        if let geo = geoLocation {
            
            let geoParameters: Parameters = [
                "lat" : geo.lat,
                "long" : geo.long
            ]
            parameters["gpsLocation"] = geoParameters
        }
        
        if let acceptedClients = clients {
            
            let clientsParameters: Parameters = [
                "men" : acceptedClients.men,
                "women" : acceptedClients.women,
                "children" : acceptedClients.children,
                "veterans" : acceptedClients.veterans,
                "disabled" : acceptedClients.disabled
            ]
            parameters["acceptedClients"] = clientsParameters
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(RemoteServiceManager.retrieveToken() ?? "")"
        ]
        
        Alamofire.request(updateUrl, parameters: parameters, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let provider = Provider(fromJSON: json)
                completion(provider)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
        
    }
    
    static func sampleProviderIdentifier() -> String {
        return "56bafde0-d2bd-44b5-8f09-8a30d1647eaa"
    }
    
    static func baseURL() -> String {
        return "https://morning-bayou-42533.herokuapp.com"
    }
    
    static func storeAuthenticationToken(token: String) {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "token")
    }
    
    static func retrieveToken() -> String? {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "token") {
            return token
        }
        return nil
    }
    
    static func clearToken() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "token")
    }
}
