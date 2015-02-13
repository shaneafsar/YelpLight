//
//  ViewController.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/8/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    @IBOutlet weak var searchInput: UISearchBar!

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
    
    var currentRequest:AFHTTPRequestOperation?
    
    var currentSearchText:String?
    
    var Businesses:[Business]?
    
    var totalBusinesses:Int?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.searchInput.translucent = true
        self.navigationItem.titleView = self.searchInput

    }
    
    override func viewWillDisappear(animated:Bool) {
        super.viewWillDisappear(animated)
        searchInput.endEditing(true)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        searchInput.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView(frame:CGRectZero)
        
        filterButton.title = "Filter"
        
        
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        

        //getBusinessResults("chipotle")
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            currentSearchText = searchText
            self.Businesses = nil
            getBusinessResults(searchText, offset: 0)
        }
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
        cell.backgroundColor = UIColor.clearColor()
        cell.sizeToFit()
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        if let businesses = Businesses, let total = totalBusinesses{
            if indexPath.row == businesses.count - 10 && businesses.count != total{
                if let searchTerm = currentSearchText{
                    getBusinessResults(searchTerm, offset: businesses.count)
                }
            }
        }
    }
    
    func getBusinessResultsTest(){
        self.Businesses = [
            Business(data: ["name":"Yelp long name"]),
            Business(data: ["name":"Yelp again okay, let's hope this wraps to the next line"]),
            Business(data: ["name":"In-N-Out"])
        ]
    }
    
    func getBusinessResults(searchTerm: String, offset:Int) -> Void {
        //println(searchTerm)
        let isFreshSearch = offset == 0
        YelpClient.sharedInstance.searchWithTerm(
            searchTerm,
            location: "San Francisco",
            limit: 20,
            offset: offset,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                var moreBusinesses:[Business]?
                moreBusinesses <<<<* response["businesses"]
                self.totalBusinesses <<< response["total"]
                
                //Loop through and add user location to models.
                //also add models if this is a pagination request
                if let businesses = moreBusinesses {
                    for business in businesses {
                        business.userLocationLat = self.lat
                        business.userLocationLon = self.long
                        //println(business.title)
                        if !isFreshSearch {
                            self.Businesses?.append(business)
                        }
                    }
                }
                
                //Set models if this is a fresh request
                if isFreshSearch{
                    self.Businesses = moreBusinesses
                }
                
                self.tableView.reloadData()
                
                //scroll to top if new search
                if isFreshSearch{
                    self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                //self.getBusinessResultsTest()
                //self.tableView.reloadData()
                println(error)
                println("crap!!")
            })
    }


}

