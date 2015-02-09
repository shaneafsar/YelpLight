//
//  ViewController.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/8/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getBusinessResults("chi")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBusinessResults(searchTerm: String) -> Void {
        YelpClient.sharedInstance.searchWithTerm(searchTerm, location: "Mountain View", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in

            let businesses = response["businesses"] as NSArray
            
            for business in businesses {
                //business["image_url"]
                //business["mobile_url"]
                println(business["name"])
            }

            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }


}

