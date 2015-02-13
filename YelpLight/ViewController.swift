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
    
    var lat:Double?{
        var _lat:Double?
        if(CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse){
            _lat = locManager.location.coordinate.latitude
        }
        return _lat
    }
    var long:Double?{
        var _num:Double?
        if(CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse){
            _num = locManager.location.coordinate.longitude
        }
        return _num
    }

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
        

        getBusinessResults("chipotle")
        

        
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
            cell.setProperties(businesses[index], number: index+1)
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
    
    func getBusinessResults(searchTerm: String) -> Void {
        YelpClient.sharedInstance.searchWithTerm(
            searchTerm,
            location: "San Francisco",
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                var test = response["businesses"]
                println("\(test)")
                self.Businesses <<<<* response["businesses"]
                
                if let businesses = self.Businesses{
                    for business in businesses {
                        business.userLocationLat = self.lat
                        business.userLocationLon = self.long
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
    }


}

