//
//  ElectionDetailViewController.swift
//  ElectionInfo
//
//  Created by Adam McKnight on 3/11/20.
//  Copyright © 2020 Adam McKnight. All rights reserved.
//

import SwiftUI
class ElectionDetailViewController : UIViewController {
   
    @IBOutlet weak var eDate: UILabel!
    @IBOutlet weak var eName: UILabel!
    @IBOutlet weak var specialText: UILabel!
    @IBOutlet weak var locName: UILabel!
    @IBOutlet weak var streetAd: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var stateName: UILabel!
    @IBOutlet weak var zipText: UILabel!
    @IBOutlet weak var hoursText: UILabel!
    
    var eID: String?
    var name: String?
    var Etype: String?
    var spec : String?
    var date : String?
    var zip : String?
    var street : String?
    var city : String?
    var loc : String?
    var state : String?
    var hours : String?
    
    override func viewDidLoad() {
        eDate.text = date
        eName.text = name
        if spec == "f" {
            specialText.text = "False"
        }
        else {
            specialText.text = "True"
        }
        locName.text = loc
        cityName.text = city
        streetAd.text = street
        zipText.text = zip
        stateName.text = state
        hoursText.text = hours
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    //public var eID = 0;
    //let url = http://api.votesmart.org/Candidates.getByElection?key=ffda6850c2f0408aae0d87eb5d8a3e2d&electionId="
        //url = url + eID
        //make api call, fill in fields
}
