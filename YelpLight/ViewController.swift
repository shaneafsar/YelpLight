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
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YelpBusinessCell") as! YelpBusinessCell
        cell.bizTitle.text = "Yelper!"
        return cell
    }
    
    func getBusinessResults(searchTerm: String) -> Void {
        YelpClient.sharedInstance.searchWithTerm(
            searchTerm,
            location: "Mountain View",
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in

                let businesses = response["businesses"] as! NSArray
            
                for business in businesses {
                    //business["image_url"]
                    //business["mobile_url"]
                    println(business["name"])
                }

            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
                println("crap!!")
            })
    }


}

