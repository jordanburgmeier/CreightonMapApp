//
//  LocationModel.swift
//  draftCSC599
//
//  Created by Jordan Burgmeier on 11/14/20.
//  Copyright © 2020 Jordan Burgmeier. All rights reserved.
//
// this protocol will transfer data from the home model to the view controller


import UIKit
import Foundation

class LocationModel: NSObject {
    
    //properties are listed here are ALL strings , seemed the easiest way to work
    
    var department: String?
    var date: String?
    var event: String?
    var venue: String?
    var location: String?
    var startTime: String?
    var endTime: String?
    
    //empty constructor
    
    override init()
    {
   // this one is empty on purpose
    }
    
    //construct with the parameters being used
    
    init(department: String, date: String, event: String, venue: String, location: String, startTime: String, endTime: String) {
        
        self.department = department
        self.date = date
        self.event = event
        self.venue = venue
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
    }

    //prints object's current state , from the php page , i hope
    
    /*override var description: String {
        
        return "Department: \(String(describing: department)), Date: \(String(describing: date)), Event: \(String(describing: event)), Venue: \(String(describing: venue)), Location: \(String(describing: location)), Event begins: \(String(describing: startTime)), Event ends:\(String(describing: endTime))"
        
        // not sure which one works here ^^^  could be the one below but i kept getting errors
        //return "Department: \(department), Date: \(date), Event: \(event), Venue: \(venue), Location: \(location), Event begins: \(startTime), Event ends:\(endTime)"
        
    }
 */
}
