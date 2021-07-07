//
//  eventListTab.swift
//  draftCSC599
//
//  Created by Jordan Burgmeier on 11/2/20.
//  Copyright © 2020 Jordan Burgmeier. All rights reserved.
//

/*
import Foundation

class ViewController:
    UIViewController {

    @IBOutlet weak var listTableView: UITableView!
}
*/


import UIKit

class eventListTab: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, HomeModelProtocol  {
    
    
    //Properties
    
    let sections = ["2020-10-26", "2020-10-27", "2020-10-28", "2020-10-29", "2020-10-30", "2020-10-31", "2020-11-1"]
    
    var TableData = [String]()
    var filteredTableData = [String]()
    
    var mondayArray = [String]()
    var tuesdayArray = [String]()
    var wednesdayArray = [String]()
    var thursdayArray = [String]()
    var fridayArray = [String]()
    var saturdayArray = [String]()
    var sundayArray = [String]()
    
    var feedItems: NSArray = NSArray()
    var selectedLocation : LocationModel = LocationModel()
    var resultSearchController = UISearchController()
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            listTableView.tableHeaderView = controller.searchBar
            return controller
        })()
        //set delegates and initialize homeModel
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        listTableView.rowHeight = UITableView.automaticDimension
        listTableView.estimatedRowHeight = 100
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
    }
    
    func itemsDownloaded(items: NSArray) {
        
        feedItems = items
        self.listTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (resultSearchController.isActive) {
            return filteredTableData.count
        }
        else {
            return feedItems.count
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (TableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        
        self.listTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve cell
        let cellIdentifier: String = "eventCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item: LocationModel = feedItems[indexPath.row] as! LocationModel
        
        // Get references to labels of cell, checks to see if array contains string already, will not append more than once if that is the case
        if TableData.contains("\(item.event!) | \(item.date!) | \(item.department!) | \(item.location!) | \(item.venue!) |  \(item.startTime!) -  \(item.endTime!)") == false {
            TableData.append("\(item.event!) | \(item.date!) | \(item.department!) | \(item.location!) | \(item.venue!) |  \(item.startTime!) -  \(item.endTime!)")
        }
        if (resultSearchController.isActive) {
            myCell.textLabel!.text = filteredTableData[indexPath.row]
        }
        else {
            /* Trying to place the cells in their own sections for section in sections {
            if section == item.date! {}}*/
            myCell.textLabel!.text = "\(item.event!) | \(item.date!) | \(item.department!) | \(item.location!) | \(item.venue!) |  \(item.startTime!) -  \(item.endTime!)"
        }
        return myCell
    }
    
}
