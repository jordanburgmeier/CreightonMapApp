//
//  HomeModel.swift
//  draftCSC599
//
//  Created by Jordan Burgmeier on 11/14/20.
//  Copyright © 2020 Jordan Burgmeier. All rights reserved.
//

import UIKit
protocol HomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class HomeModel: NSObject, URLSessionDataDelegate {

    //properties
    weak var delegate: HomeModelProtocol!
    
    //var data = Data()
    
    let urlPath = "http://katherinelibby.com/capstone599Connection.php" //this is where our connection.php file is located on the host server

    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }

    func parseJSON(_ data:Data) {
        var jsonResult = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print([jsonResult])
            print(error)
        }
        var jsonElement = NSDictionary()
        let allEvents = NSMutableArray()
        for i in 0 ..< jsonResult.count
        {
            jsonElement = jsonResult[i] as! NSDictionary
            
            let theEvent = LocationModel()
//the following insures none of the JsonElement values are nil through optional binding
            
            // department, date, event, vanue, location, startTime, endTime
            // for reference these are the mySQL columns used
            
            if let department = jsonElement["department"] as? String,
               let date = jsonElement["date"] as? String,
                let event = jsonElement["event"] as? String,
                let venue = jsonElement["venue"] as? String,
                let location = jsonElement["location"] as? String,
                let startTime = jsonElement["startTime"] as? String,
                let endTime = jsonElement["endTime"] as? String
            {
                
                theEvent.department = department
                theEvent.date = date
                theEvent.event = event
                theEvent.venue = venue
                theEvent.location = location
                theEvent.startTime = startTime
                theEvent.endTime = endTime
                
            }
            allEvents.add(theEvent)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: allEvents)
        }
        )
    }
}
