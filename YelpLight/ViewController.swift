//
//  ViewController.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/8/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    var locManager = CLLocationManager()

    var Businesses:[Business]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        filterButton.title = "Filter"
        
        
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        
        if(CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse){
            
            var currentCoord = locManager.location.coordinate
            println("\(currentCoord.longitude)")

            getBusinessResults("chi", lat: String(format: "%f", currentCoord.latitude) , long: String(format: "%f", currentCoord.longitude))
        }else{
            getBusinessResults("chi", lat:nil, long:nil)
            println("not authorized")
        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Businesses?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YelpBusinessCell") as! YelpBusinessCell
        
        if let businesses = Businesses{
            var index = indexPath.row
            cell.setProperties(businesses[indexPath.row], number: index+1)
        }
        
        cell.sizeToFit()
        return cell
    }
    
    func getBusinessResultsTest(){
        self.Businesses = [
            Business(data: ["name":"Yelp long name"]),
            Business(data: ["name":"Yelp again okay, let's hope this wraps to the next line"]),
            Business(data: ["name":"In-N-Out"])
        ]
    }
    
    func getBusinessResults(searchTerm: String, lat:String?, long:String?) -> Void {
        YelpClient.sharedInstance.trySearchWithTermCurrentLocation(
            searchTerm,
            location: "Mountain View",
            lat: lat,
            long: long,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
                self.Businesses <<<<* response["businesses"]
                
                if let businesses = self.Businesses{
                    for business in businesses {
                        println(business.title)
                    }
                }
                
                self.tableView.reloadData()

            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.getBusinessResultsTest()
                self.tableView.reloadData()
                println(error)
                println("crap!!")
            })
        //self.tableView.rowHeight = UITableViewAutomaticDimension
    }


}

