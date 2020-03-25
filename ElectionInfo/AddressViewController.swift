//
//  AddressViewController.swift
//  ElectionInfo
//
//  Created by Adam McKnight on 3/12/20.
//  Copyright © 2020 Adam McKnight. All rights reserved.
//

import SwiftUI
protocol AddressDelegate {
    func sendBack(returnAdd : Address)
}
let States = [
    "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
]
class AddressViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var backButton: UINavigationItem!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var zipText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var streetText: UITextField!
    var delegate : AddressDelegate?
    var addr = Address()
    var hasChanged = false
    var abr = ""
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return States.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return States[row]
    }
    
    @IBAction func submitAddress(_ sender: Any) {
        let t : Int = 0
        let selectedRow : Int = statePicker.selectedRow(inComponent: t)
        let s = States[selectedRow]
        if (!streetText.text!.isEmpty && !cityText.text!.isEmpty &&  !zipText.text!.isEmpty){
            let formattedString = streetText.text!.replacingOccurrences(of: " ", with: "%20")
            let cityString = cityText.text!.replacingOccurrences(of: " ", with: "%20")
            addr.street = formattedString
            addr.city = cityString
            addr.state = s
            addr.zip = zipText.text!
            getStateAbr(stateName: s)
            addr.abr = abr
            let title = "Address Changed"
            let message = "Address Change Successful"
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(okayAction)
            hasChanged = true
            present(alertController, animated: true, completion: nil)
        }
        else {
            let title = "Invalid Input"
            let message = "You must enter a value in each field"
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            
        }
        delegate?.sendBack(returnAdd: addr)
        
    }
    
    func getStateAbr(stateName : String){
        switch addr.state
        {
            case ""                 : break
            case "Arkansas"         : abr = "AR"
            case "New Hampshire"    : abr = "NH"
            case "Iowa"             : abr = "IA"
            case "Illinois"         : abr = "IL"
            case "New York"         : abr = "NY"
            case "California"       : abr = "CA"
            case "Alabama"          : abr = "AL"
            case "New Jersey"       : abr = "NJ"
            case "Rhode Island"     : abr = "RI"
            case "Nevada"           : abr = "NV"
            case "South Carolina"   : abr = "SC"
            case "North Carolina"   : abr = "NC"
            case "South Dakota"     : abr = "SD"
            case "North Dakota"     : abr = "ND"
            case "Wyoming"          : abr = "WY"
            case "Idaho"            : abr = "ID"
            case "Arizona"          : abr = "AZ"
            case "Colorado"         : abr = "CO"
            case "Connecticut"      : abr = "CT"
            case "Delaware"         : abr = "DE"
            case "Florida"          : abr = "FL"
            case "Georgia"          : abr = "GA"
            case "Hawaii"           : abr = "HI"
            case "Indiana"          : abr = "IN"
            case "Minnesota"        : abr = "MN"
            case "Kentucky"         : abr = "KY"
            case "Kansas"           : abr = "KS"
            case "Louisiana"        : abr = "LA"
            case "Maine"            : abr = "ME"
            case "Maryland"         : abr = "MD"
            case "Massachusetts"    : abr = "MA"
            case "Michigan"         : abr = "MI"
            case "Mississippi"      : abr = "MS"
            case "Missouri"         : abr = "MO"
            case "Montana"          : abr = "MT"
            case "Nebraska"         : abr = "NE"
            case "New Mexico"       : abr = "NM"
            case "Ohio"             : abr = "OH"
            case "Pennsylvania"     : abr = "PA"
            case "Tennesse"         : abr = "TN"
            case "Texas"            : abr = "TX"
            case "Utah"             : abr = "UT"
            case "Vermont"          : abr = "VT"
            case "Virginia"         : abr = "VA"
            case "West Virginia"    : abr = "WV"
            case "Wisconsin"        : abr = "WI"
            case "Oklahoma"         : abr = "OK"
            case "Alaska"           : abr = "AK"
            case "Oregon"           : abr = "OR"
            case "Washington"       : abr = "WA"
            case "District of Columbia" : abr = "DC"
            default                 : break
        }
    }
    
    @IBAction func didEndOnExit(_ sender: UITextField) {
        sender.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true;
    }
}
