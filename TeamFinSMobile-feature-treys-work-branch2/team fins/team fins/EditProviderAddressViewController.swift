//
//  EditProviderAddressViewController.swift
//  team fins
//
//  Created by Trey Baugher on 10/22/16.
//  Copyright © 2016 Team Fins. All rights reserved.
//

import UIKit

class EditProviderAddressViewController: UIViewController {
    let data = ["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    
    @IBOutlet weak var addressField1: UITextField?
    @IBOutlet weak var addressField2: UITextField?
    @IBOutlet weak var cityField: UITextField?
    @IBOutlet weak var zipcodeField: UITextField?
    @IBOutlet weak var errorLabel: UILabel?
    @IBOutlet weak var statePicker : UIPickerView?
    @IBOutlet weak var newProviderButtons: UIView?
    @IBOutlet weak var existingProviderButtons: UIView?
    
    var provider: Provider?
    weak var updateReceiver: ReceivesProviderUpdates?

    class func newController(forProvider provider: Provider, updateReceiver: ReceivesProviderUpdates?) -> EditProviderAddressViewController {
        let vc = EditProviderAddressViewController.init(nibName: "EditProviderAddressViewController", bundle: nil)
        vc.provider = provider
        vc.updateReceiver = updateReceiver
        vc.updateFields()
        return vc
    }
    
    func updateFields() {
        guard let provider = provider else { return }
        let isExistingProvider = provider.locationName.characters.count > 0
        newProviderButtons?.isHidden = isExistingProvider
        existingProviderButtons?.isHidden = !isExistingProvider
        
        addressField1?.text = provider.address.line1
        addressField2?.text = provider.address.line2
        cityField?.text = provider.address.city
        zipcodeField?.text = (provider.address.zip == 0 ? "" : "\(provider.address.zip)" )
        if provider.address.state.characters.count == 2 {
            let state = provider.address.state
            let index = indexFor(state: state)
            statePicker?.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    func validateFields() -> (Bool, String?, Address?) {
        guard let address1 = addressField1?.text else { return (false, "Please provide a valid address", nil) }
        guard let city = cityField?.text else { return (false, "Please provide a valid address", nil) }
        guard let zipcode = zipcodeField?.text else { return (false, "Please provide a valid address", nil) }
        guard let zip = Int(zipcode) else { return (false, "Please provide a valid address", nil) }
        guard let statePicker = statePicker else { return (false, "Please provide a valid address", nil) }
        
        let stateI = statePicker.selectedRow(inComponent: 0)
        let state = data[stateI]
        let address2 = addressField2?.text
        
        let addy = Address.init(line1: address1, line2: address2, city: city, state: state, zip: zip)
        
        return (true, nil, addy)
    }

    func indexFor(state: String) -> Int {
        for (index, element) in data.enumerated() {
            if element == state { return index }
        }
        return 0
    }
    
    @IBAction func saveChanges() {
        let result = validateFields()
        guard result.0 else {
            errorLabel?.text = result.1
            return
        }
        
        guard let model = result.2 else { return }
        ProviderInteractor.locationFromAddress(address: model) {
            [weak self] gps in
            guard let currentProvider = self?.provider else { return }
            RemoteServiceManager.updateProviderFor(providerId: "\(currentProvider.uid)", phoneNumber: nil, locationName: nil, description: nil, totalBeds: nil, occupiedBeds: nil, intakeStart: nil, intakeEnd: nil, addressObject: model, geoLocation: gps, clients: nil) {
                [weak self] provider in
                if let promodel = provider {
                    self?.updateReceiver?.providerUpdated(provider: promodel)
                }
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            
        }
        //todo: inform provider of update
    }
    
    @IBAction func cancelEdit() {
         navigationController?.popViewController(animated: true)
    }
}

extension EditProviderAddressViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
}
