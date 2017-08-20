//
//  SosTasks.swift
//  ClientConnect
//
//  Created by Ali Khaliq on 8/20/17.
//  Copyright © 2017 Humber. All rights reserved.
//

import Foundation


class SosTasks{
    
    var name:String
    var description:String
    var notes:String
    
    init (name: String,description: String, notes: String) {
        self.name = name
        self.description = description
        self.notes = notes
    }
    
    
    func getName() ->String {
        return name
    }
    
    func getDescription() -> String {
        return description
    }
    
    func getNotes() -> String {
        return notes
    }
    
}
