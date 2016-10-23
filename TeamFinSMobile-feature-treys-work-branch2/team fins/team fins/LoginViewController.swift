//
//  ViewController.swift
//  team fins
//
//  Created by Trey Baugher on 10/22/16.
//  Copyright © 2016 Team Fins. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField?
    @IBOutlet weak var passwordField: UITextField?
    @IBOutlet weak var errorLabel: UILabel?
    
    @IBAction func attemptLogin() {
        errorLabel?.isHidden = true
        guard let username = usernameField?.text else { return }
        guard let password = passwordField?.text else { return }

        RemoteServiceManager.authenticateUser(username: username, password: password) {
            [weak self] responseProvider in
            DispatchQueue.main.async {
                guard let provider = responseProvider else {
                    self?.failedLabel(withTitle: "Login Failed")
                    return
                }
                
                guard provider.locationName.characters.count > 0 else {
                    let vc = EditProviderDetailsViewController.newController(forProvider: provider, updateReceiver: nil)
                    self?.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                let vc = IntakeCounterViewController.newController(provider: provider)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    @IBAction func createAccount() {
        errorLabel?.isHidden = true
        let accountController = CreateAccountViewController.newController()
        navigationController?.pushViewController(accountController, animated: true)
    }
    
    func failedLabel(withTitle: String) {
        errorLabel?.text = withTitle
        errorLabel?.isHidden = false
    }
    
    func clearFields() {
        usernameField?.text = ""
        passwordField?.text = ""
    }
}

