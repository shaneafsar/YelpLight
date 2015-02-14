//
//  FilterViewController.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/9/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var sections = ["Test","Distance","Sort by","Category"]
    /*
    var settings = [
        0:[["label":"Deals","type":"checkbox", "filter":"deals", "value":true]],
        1:[
            ["label":"Best Match" ,  "type":"radio", "filter":"radius", "value":"best"],
            ["label":"0.3 miles"  ,  "type":"radio", "filter":"radius", "value":482.8032],
            ["label":"1 mile"     ,  "type":"radio", "filter":"radius", "value":1609.34],
            ["label":"5 miles"    ,  "type":"radio", "filter":"radius", "value":8046.72],
            ["label":"20 miles"   ,  "type":"radio", "filter":"radius", "value":32186.9]
        ],
        // distance, highest rated)
        2:[
            ["label":"Best match"       ,"type":"checkbox", "filter":"sort", "value":"best"],
            ["label":"Distance"         ,"type":"checkbox", "filter":"sort", "value":"distance"],
            ["label":"Highest rated"    ,"type":"checkbox", "filter":"sort", "value":"rated"]
        ],
        3:[["label":"Deals","type":"checkbox"]]
    ]
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 75
        tableView.tableFooterView = UIView(frame:CGRectZero)
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //deals (on/off), radius (meters), sort (best match, distance, highest rated), category
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        return 3
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderCell;
        
        let text:String
        
        switch (section) {
            case 1:
                text = sections[1]
            case 2:
                text = sections[2]
            case 3:
                text = sections[3]
            default:
                text = sections[0]
        }
        
        headerCell.labelTitle.text = text
        
        return headerCell
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YelpSettingsCell") as! YelpSettingsCell;
        cell.settingsLabel.text = "Setting \(indexPath.row)"
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
