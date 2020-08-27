//
//  DataStylize.swift
//  Pokedex
//
//  Created by Kelly Ho on 2020-08-25.
//  Copyright © 2020 Inc. All rights reserved.
//

import Foundation

struct DataStylize {
    
    var id: Int

    
    // https://www.hackingwithswift.com/read/0/18/static-properties-and-methods
     static func indexConvert(id: Int) -> String {
        
        var idStr = String(id)
        let idCount = idStr.count
        
        if idCount == 2 {
            idStr = "0\(idStr)"
        }
        
        if idCount == 1 {
            idStr = "00\(idStr)"
        }
        
        return idStr
    }
}

