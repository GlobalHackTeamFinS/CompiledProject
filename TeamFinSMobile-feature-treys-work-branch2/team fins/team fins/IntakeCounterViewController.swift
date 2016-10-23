//
//  IntakeCounterViewController.swift
//  team fins
//
//  Created by Trey Baugher on 10/22/16.
//  Copyright © 2016 Team Fins. All rights reserved.
//

import UIKit

protocol ReceivesProviderUpdates: class {
    func providerUpdated(provider: Provider)
}

class IntakeCounterViewController: UIViewController {
    
    @IBOutlet weak var roomNumberLabel: UILabel?
    var provider: Provider?
    
    class func newController(provider: Provider) -> IntakeCounterViewController {
        let vc = IntakeCounterViewController.init(nibName: "IntakeCounterViewController", bundle: nil)
        vc.providerUpdated(provider: provider)
        return vc
    }

    @IBAction func incrementNumber() {
        guard let provider = provider else { return }
        guard provider.occupiedBeds > 0 else { return }

        roomNumberLabel?.text = "\(provider.totalBeds - provider.occupiedBeds - 1)"
        RemoteServiceManager.incrementOccupancyFor(providerId: "\(provider.uid)") {
            [weak self] success in
            if success {
                //TODO// use returned provider self?.providerUpdated(provider:)
            } else {
                guard let provider = self?.provider else { return }
                self?.providerUpdated(provider:provider)
            }
        }
    }
    
    @IBAction func decrementNumber() {
        guard let provider = provider else { return }
        guard provider.totalBeds != provider.occupiedBeds else { return }

        roomNumberLabel?.text = "\(provider.totalBeds - provider.occupiedBeds + 1)"
        RemoteServiceManager.decrementOccupancyFor(providerId: "\(provider.uid)") {
            [weak self] success in
            if success {
                //TODO// use returned provider self?.providerUpdated(provider:)
            } else {
                guard let provider = self?.provider else { return }
                self?.providerUpdated(provider:provider)
            }
        }
    }
    
    @IBAction func logout() {
        //TODO: inform remote service
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func editAddress() {
        guard let provider = provider else { return }
        let vc = EditProviderAddressViewController.newController(forProvider: provider, updateReceiver: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editDetails() {
        guard let provider = provider else { return }
        let vc = EditProviderDetailsViewController.newController(forProvider: provider, updateReceiver: self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension IntakeCounterViewController: ReceivesProviderUpdates {
    func providerUpdated(provider: Provider) {
        DispatchQueue.main.async {
            self.provider = provider
            self.roomNumberLabel?.text = "\(provider.totalBeds - provider.occupiedBeds)"
        }
    }
}
