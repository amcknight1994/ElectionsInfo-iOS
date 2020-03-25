//
//  ElectionsView.swift
//  ElectionInfo
//
//  Created by Adam McKnight on 3/5/20.
//  Copyright © 2020 Adam McKnight. All rights reserved.
//

import UIKit

struct pLocations : Codable {
    let pollingLocations : [pLocation]
}
struct pLocation : Codable {
    var address : addr
    var notes: String
    var pollingHours: String
    var sources: [source]
}

struct addr : Codable {
    let locationName : String
    let line1: String
    let city: String
    let state: String
    let zip: String
}

struct source: Codable {
    let name: String
    let official: Bool
}



class ElectionsView: UITableViewController , AddressDelegate {
    public var zip = "60605"
    var elections : [election] = []
    var eTitle = ""
    var address = Address()
    var pollLoc = pLocation(address: addr(locationName: "",line1: "",city: "",state: "",zip: ""), notes: "", pollingHours: "", sources: [])
    var adString = ""
    var stateABR = "IL"

    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeGesture.direction = .left
        view.addGestureRecognizer(swipeGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callVote()
        callGoogle()
    }
    
    func sendBack(returnAdd : Address){
        address = returnAdd
        stateABR = returnAdd.abr
        zip = returnAdd.zip
        callGoogle()
        callVote()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return elections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        cell.textLabel!.numberOfLines = 2;
        cell.textLabel!.text = elections[indexPath.section].name
        return cell
    }
    
    
    func callGoogle() {
        var webAddr : String
        if (address.isComplete()){
            adString = address.street + "%20" + address.city + "%20" + address.state;
            webAddr = "https://www.googleapis.com/civicinfo/v2/voterinfo?address=" + adString + "&electionId=2000&officialOnly=true&fields=pollingLocations&key=AIzaSyA0y-7pLPUtoJME0najH7SFE2fvMnur2xU"
        }
        else {
            webAddr = "https://www.googleapis.com/civicinfo/v2/voterinfo?address=1%20e%20jackson%20blvd%20chicago%20illinois&electionId=2000&officialOnly=true&fields=pollingLocations&key=AIzaSyA0y-7pLPUtoJME0najH7SFE2fvMnur2xU"
        }
        guard let apiURL = URL(string: webAddr) else {return}
        URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
            if error != nil { print (error!.localizedDescription) }
            guard let data = data else { return }
            
            do
            {
                let response = try JSONDecoder().decode(pLocations.self, from: data)
                DispatchQueue.main.async
                {
                    self.pollLoc.address = response.pollingLocations[0].address
                    self.pollLoc.notes = response.pollingLocations[0].notes
                    self.pollLoc.pollingHours = response.pollingLocations[0].pollingHours
                    self.pollLoc.notes = response.pollingLocations[0].notes
                    self.pollLoc.sources = response.pollingLocations[0].sources
                }
            }
            catch let jsonError { print(jsonError) }
        }
        .resume()
    }
    
    func callVote() {
        let postEndpoint: String = "http://api.votesmart.org/Election.getElectionByYearState?key=ffda6850c2f0408aae0d87eb5d8a3e2d&year=2020&stateId=" + stateABR
        let APIurl = URL(string: postEndpoint)!
        let request = URLRequest(url: APIurl)

        URLSession.shared.dataTask(with: request) {
            ( data,_, error) -> Void in
            
            if error != nil
            {
                print(error!)
                return
            }
            guard let data = data else { return }
            let del = XMLParserT()
            del.setData(data: data)
            let x = XMLParser(data: data)
            x.delegate = del
            x.parse()
            self.elections = del.elections
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }

    
    func handleSwipeGesture(gesture: UISwipeGestureRecognizer) {
         performSegue(withIdentifier: "changeLoc", sender: self)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetails"){
            guard let detailViewController = segue.destination as? ElectionDetailViewController else { return }
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = self.tableView.indexPath(for: cell) else { return }
            detailViewController.Etype = elections[indexPath.section].Stage.stageName
            detailViewController.eID = elections[indexPath.section].electionId
            detailViewController.spec = elections[indexPath.section].special
            detailViewController.date = elections[indexPath.section].Stage.electionDate
            detailViewController.name = elections[indexPath.section].name
            detailViewController.city = pollLoc.address.city
            detailViewController.state = pollLoc.address.state
            detailViewController.street = pollLoc.address.line1
            detailViewController.loc = pollLoc.address.locationName
            detailViewController.zip = zip
            if (pollLoc.pollingHours.isEmpty){
                detailViewController.hours = "Not Available"
            }
            else {
                detailViewController.hours = pollLoc.pollingHours
            }
        }
        if (segue.identifier == "changeLoc"){
             guard let addrViewController = segue.destination as? AddressViewController else { return }
             addrViewController.addr = address
             addrViewController.delegate = self
        }
    }
}
