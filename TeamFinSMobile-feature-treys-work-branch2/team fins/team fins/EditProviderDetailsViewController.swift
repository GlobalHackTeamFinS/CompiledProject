//
//  EditProviderDetailsViewController.swift
//  team fins
//
//  Created by Trey Baugher on 10/22/16.
//  Copyright © 2016 Team Fins. All rights reserved.
//

import UIKit

class EditProviderDetailsViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel?
    @IBOutlet weak var newProviderButtons: UIView?
    @IBOutlet weak var existingProviderButtons: UIView?
    
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var bedCountField: UITextField?
    @IBOutlet weak var phoneField: UITextField?
    @IBOutlet weak var descriptionField: UITextView?
    @IBOutlet weak var startTimePicker: UIDatePicker?
    @IBOutlet weak var endTimePicker: UIDatePicker?
    
    @IBOutlet weak var menClientView: ClientTypeView? {
        didSet {
            menClientView?.representType(name: "men")
        }
    }
    @IBOutlet weak var womenClientView: ClientTypeView? {
        didSet {
            womenClientView?.representType(name: "women")
        }
    }
    @IBOutlet weak var childrenClientView: ClientTypeView? {
        didSet {
            childrenClientView?.representType(name: "family")
        }
    }
    @IBOutlet weak var veteranClientView: ClientTypeView? {
        didSet {
            veteranClientView?.representType(name: "veteran")
        }
    }
    @IBOutlet weak var disabledClientView: ClientTypeView? {
        didSet {
            disabledClientView?.representType(name: "disabled")
        }
    }
    
    var provider: Provider?
    weak var updateReceiver: ReceivesProviderUpdates?
    
    class func newController(forProvider provider: Provider, updateReceiver: ReceivesProviderUpdates?) -> EditProviderDetailsViewController {
        let vc = EditProviderDetailsViewController.init(nibName: "EditProviderDetailsViewController", bundle: nil)
        vc.provider = provider
        vc.updateReceiver = updateReceiver
        vc.updateFields()
        return vc
    }
    
    @IBAction func cancelEdits() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveEdits() {
        let result = validateFields()
        
        guard let provider = provider else { return }
        let notFirstTime = provider.locationName.characters.count > 0
        if result.0 {
            let men = menClientView?.selected ?? false
            let women = womenClientView?.selected ?? false
            let children = childrenClientView?.selected ?? false
            let veterans = veteranClientView?.selected ?? false
            let disabled = disabledClientView?.selected ?? false
            
            let clients = AcceptedClients(men: men,
                                            women: women,
                                            children: children,
                                            veterans: veterans,
                                            disabled: disabled)
            
            let date = startTimePicker?.date
            let calendar = NSCalendar.current
            var components = calendar.dateComponents([.hour, .minute], from:date!)
            let minutes = components.minute ?? 0
            let hours = components.hour ?? 0
            let startTime = hours * 60 + minutes
            
            let date2 = endTimePicker?.date
            let calendar2 = NSCalendar.current
            var components2 = calendar2.dateComponents([.hour, .minute], from:date2!)
            let minutes2 = components2.minute ?? 0
            let hours2 = components2.hour ?? 0
            let endTime = hours2 * 60 + minutes2
            
            let beds = bedCountField?.text?.digits ?? "0"
            let bedAmount = Int(beds) ?? 0
            
            let phoneFormat = phoneField?.text ?? "0000000000"
            let a = phoneFormat.insert(string:"(", ind: 0)
            let b = a.insert(string:")", ind: 4)
            let c = b.insert(string:"-", ind: 5)
            let phone = c.insert(string:"-", ind: 9)
            
            let postBeds = provider.totalBeds != bedAmount
            
            RemoteServiceManager.updateProviderFor(providerId: "\(provider.uid)",
            phoneNumber: phone, locationName: nameTextField?.text,
            description: descriptionField?.text,
            totalBeds: (postBeds ? bedAmount : nil ),
            occupiedBeds: nil,
            intakeStart: startTime,
            intakeEnd: endTime,
            addressObject: nil,
            geoLocation: nil,
            clients: clients) {
                [weak self] provider in
                guard let promodel = provider else{
                    DispatchQueue.main.async {
                        self?.errorLabel?.text = "save failed"
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self?.updateReceiver?.providerUpdated(provider: promodel)

                    if notFirstTime {
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        let vc = EditProviderAddressViewController.newController(forProvider: promodel, updateReceiver: nil)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            
        } else {
            errorLabel?.text = result.1
        }
    }
    
    func validateFields() -> (Bool, String?) {
        guard let _ = nameTextField?.text else { return (false, "please enter a facility name")}
        guard let beds = bedCountField?.text?.digits else { return (false, "please enter a valid bed amount ")}
        guard let _ = Int(beds) else { return (false, "please enter a valid bed amount ")}
        guard let phone = phoneField?.text?.digits else { return (false, "please enter a valid phone number")}
        guard phone.characters.count == 10 else { return (false, "please enter a valid phone number")}
        return (true, nil)
        
    }
    
    func updateFields() {
        guard let provider = provider else { return }
        let isExistingProvider = provider.locationName.characters.count > 0
        newProviderButtons?.isHidden = isExistingProvider
        existingProviderButtons?.isHidden = !isExistingProvider
        
        menClientView?.selected = provider.acceptedClients.men
        womenClientView?.selected = provider.acceptedClients.women
        childrenClientView?.selected = provider.acceptedClients.children
        veteranClientView?.selected = provider.acceptedClients.veterans
        disabledClientView?.selected = provider.acceptedClients.disabled
        
        nameTextField?.text = provider.locationName
        bedCountField?.text = "\(provider.totalBeds)"
        phoneField?.text = provider.phoneNumber
        descriptionField?.text = provider.generalDescription
        
        let calendar = NSCalendar.current
        let components = NSDateComponents()
        components.hour = provider.intakeStart/60
        components.minute = provider.intakeStart%60
        if let date = calendar.date(from: components as DateComponents) {
            startTimePicker?.setDate(date, animated: false)
        }
        
        let calendar2 = NSCalendar.current
        let components2 = NSDateComponents()
        components2.hour = provider.intakeEnd/60
        components2.minute = provider.intakeEnd%60
        if let date2 = calendar2.date(from: components2 as DateComponents) {
            endTimePicker?.setDate(date2, animated: false)
        }
    }
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined(separator: "")
    }
}

extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
}

