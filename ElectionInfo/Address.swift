//
//  Address.swift
//  ElectionInfo
//
//  Created by Adam McKnight on 3/13/20.
//  Copyright © 2020 Adam McKnight. All rights reserved.
//

import Foundation

class Address {
    var street : String = ""
    var city : String = ""
    var zip : String = ""
    var state : String = ""
    var abr : String = ""
    
    func isComplete() -> Bool{
        if (!street.isEmpty && !city.isEmpty && !state.isEmpty && !zip.isEmpty){
            return true
        }
        else { return false }
    }
}
