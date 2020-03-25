//
//  XMLParser.swift
//  ElectionInfo
//
//  Created by Adam McKnight on 3/6/20.
//  Copyright © 2020 Adam McKnight. All rights reserved.
//

import Foundation

 public struct election: Codable {
     var electionId : String
     var name : String
     var stateID : String
     var officeTypeId : String
     var special : String
     var electionYear : String
     var Stage: stage
 }

public struct stage: Codable {
    var stageID: String
    var ElectionstageId: String
    var stageName: String
    var electionDate: String
    var npatMailed: String
}
 
class XMLParserT: NSObject, XMLParserDelegate
{
    private var responseData: Data
    private var ready: Bool
    var elections : [election]
    private var currentElementName = ""
    private var inItem: Bool
    private var inStage: Bool
    private var item: election
    private var stageItem: stage
    
    override init() {
        self.elections = []
        stageItem = stage(stageID: "", ElectionstageId: "", stageName: "", electionDate: "", npatMailed: "")
        item = election(electionId: "0", name: "", stateID: "", officeTypeId: "", special: "", electionYear: "0", Stage: stageItem)
        inItem = false
        inStage = false //stage and election have attr "name" so we have to verify we aren't in stage of name will be overwritten
        currentElementName = ""
        ready = false
        responseData = "".data(using: String.Encoding.ascii)!
    }
    
    func setData(data: Data!) -> Void {
       if data == nil { return }
        responseData = data
    }
    
    func parse() -> Void{
        
    }
    
    internal func parserDidEndDocument(_ parser: XMLParser) {
        ready = true
    }
    
    internal func parserDidStartDocument(_ parser: XMLParser) {
        ready = false
    }
    
    internal func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        currentElementName = elementName
        if elementName == "election"
        {
            item.Stage = stageItem;
            inItem = false
            elections.append(item)
        }
        if elementName == "stage" { inStage = false }
    }
    
    internal func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = elementName
        if elementName == "election"
        {
            inItem = true
            item = election(electionId: "0", name: "", stateID: "", officeTypeId: "", special: "", electionYear: "0", Stage: stageItem)
        }
        
        if elementName == "stage" { inStage = true }
    
    }
    
    internal func parser(_ parser: XMLParser, foundCharacters string: String) {
       if !inItem
        {
            return
        }
        
        let properString = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if properString.count > 0
        {
            if inStage == false {
            switch currentElementName.lowercased()
                {
                case ""             : break
                case "electionid"   : item.electionId   = properString
                case "name"         : item.name         = properString
                case "stateid"      : item.stateID      = properString
                case "officetypeid" : item.officeTypeId = properString
                case "special"      : item.special      = properString
                case "electionyear" : item.electionYear = properString
                default               : break
                
                }
            }
            else {
                switch currentElementName.lowercased()
                {
                case "" : break
                case "stageid"                          : stageItem.stageID          = properString
                case "electionelectionstageid"          : stageItem.ElectionstageId  = properString
                case "name"                             : stageItem.stageName        = properString
              
                case "electiondate"                     : stageItem.electionDate     = properString
                case "npatmailed"                       : stageItem.npatMailed       = properString
                case "filingdeadline"                   : break
                default : break
                
                }
            }
        }
        if ( properString.count > 0 && inStage == true && currentElementName.lowercased() == "electiondate") { stageItem.electionDate = properString}
    }
}
