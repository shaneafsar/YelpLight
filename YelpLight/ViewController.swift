//
//  ViewController.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/8/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    var Businesses:NSArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        filterButton.title = "Filter"
        getBusinessResults("chi")
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
            cell.bizTitle.text = businesses[indexPath.row]["name"] as? String
        }
        return cell
    }
    
    func getBusinessResults(searchTerm: String) -> Void {
        YelpClient.sharedInstance.searchWithTerm(
            searchTerm,
            location: "Mountain View",
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in

                self.Businesses = response["businesses"] as? NSArray
            
                if let businesses = self.Businesses{
                    for business in businesses {
                        //business["image_url"]
                        //business["mobile_url"]
                        println(business["name"])
                    }
                }
                
                self.tableView.reloadData()

            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
                println("crap!!")
            })
    }


}

