//
//  Tasks.swift
//  ClientConnect
//
//  Created by Andrew McGuire on 8/2/17.
//  Copyright © 2017 Humber. All rights reserved.
//

class Tasks{
    
    var name:String
    var description:String
    var tech:String
    var notes:String
    var sos:Bool
    var completed:Bool
    var id:Int
    
    init(id: Int,name: String, description: String,tech: String,notes: String) {
        self.name = name
        self.description = description
        self.tech = tech
        self.sos = false
        self.notes = notes
        self.completed = false
        self.id = id
    }
    
    func getName() -> String {
        return name
    }
    
    func getDescription() -> String {
        return description
    }
    
    func getId() -> Int {
        return id
    }
    
    func setSos(boolean: Bool) {
        sos = boolean
    }
    
    
    func isSos() -> Bool {
        return sos
    }
}
