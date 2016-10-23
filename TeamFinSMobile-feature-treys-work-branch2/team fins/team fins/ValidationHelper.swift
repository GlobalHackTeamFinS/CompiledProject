//
//  ValidationHelper.swift
//  team fins
//
//  Created by Sonny Rodriguez on 10/22/16.
//  Copyright © 2016 Team Fins. All rights reserved.
//

import Foundation

struct ValidationHelper {
    static func validEmail(email: String) -> Bool {
        return email.characters.count > 0
    }
    
    static func validPassword(pass: String, confirmPass:String) -> (success: Bool, error: String?) {
        guard confirmPass == pass else {
            return (false, "Your passwords do not match")
        }
        
        guard pass.characters.count >= 8 else {
            return (false, "Your password must be at least 8 characters long")
        }
        
        guard ValidationHelper.containsLetter(text: pass) else {
            return (false, "Your password must contain a letter")
        }
        
        guard ValidationHelper.containsNumber(text: pass) else {
            return (false, "Your password must contain a number")
        }
        
        return (true, nil)
    }

    static func containsLetter(text:String) -> Bool {
        let letterRegEx  = ".*[a-zA-Z]+.*"
        let letterVerification = NSPredicate(format:"SELF MATCHES %@", letterRegEx)
        return letterVerification.evaluate(with: text)
    }

    static func containsNumber(text:String) -> Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let numberVerification = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return numberVerification.evaluate(with: text)
    }
}
