//
//  FilterViewController.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/9/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  let BgColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
  
  var sections = ["Price","Distance","Sort by","Category"]
  
  var price:[[String:AnyObject?]] = [["label":"Deals","type":"checkbox", "filter":"deals_filter", "value":true]]
  
  var distance:[[String:AnyObject?]] = [
    ["label":"Best Match" ,  "type":"radio", "filter":"radius_filter", "value":0],
    ["label":"0.3 miles"  ,  "type":"radio", "filter":"radius_filter", "value":482.8032],
    ["label":"1 mile"     ,  "type":"radio", "filter":"radius_filter", "value":1609.34],
    ["label":"5 miles"    ,  "type":"radio", "filter":"radius_filter", "value":8046.72],
    ["label":"20 miles"   ,  "type":"radio", "filter":"radius_filter", "value":32186.9]
  ]
  var sort:[[String:AnyObject?]] = [
    ["label":"Best match"       ,"type":"radio", "filter":"sort", "value":0],
    ["label":"Distance"         ,"type":"radio", "filter":"sort", "value":1],
    ["label":"Highest rated"    ,"type":"radio", "filter":"sort", "value":2]
  ]
  
  var isShowingDistance = false
  var selectedDistanceIndex = 0
  
  var isShowingSort = false
  var selectedSortIndex = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = BgColor
    tableView.backgroundColor = BgColor
    
    setTableView()
    
    selectedDistanceIndex = findIndexFor(distance, value: FilterSettingsStore.sharedInstance.getValueFor("radius_filter") as? Double)
    
    selectedSortIndex = findIndexFor(sort, value: FilterSettingsStore.sharedInstance.getValueFor("sort") as? Int)
    
    // Do any additional setup after loading the view.
  }
  
  private func refreshResults(){
    if let parentController = parentViewController as? ViewController{
      parentController.refreshBusinessResults()
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    refreshResults()
  }
  
  func findIndexFor(filters: [[String:AnyObject?]], value:Double?) -> Int{
    if let value = value{
      println("FindIndexDouble for: \(value)")
      for var index = 0 ; index < filters.count; ++index {
        if let defaultValue = filters[index]["value"] as? Double{
          if defaultValue == value{
            return index
          }
        }
      }
    }
    return 0
  }
  func findIndexFor(filters: [[String:AnyObject?]], value:Int?) -> Int{
    if let value = value{
      println("FindIndexInt for: \(value)")
      for var index = 0 ; index < filters.count; ++index {
        if let defaultValue = filters[index]["value"] as? Int{
          if defaultValue == value{
            return index
          }
        }
      }
    }
    return 0
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setTableView(){
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 75
    tableView.tableHeaderView = UIView(frame:CGRectZero)
    tableView.tableFooterView = UIView(frame:CGRectZero)
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

// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource{
  
  //deals (on/off), radius (meters), sort (best match, distance, highest rated), category
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sections.count
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numRows:Int
    switch (section) {
    case 0:
      numRows = price.count
    case 1:
      numRows = isShowingDistance ? distance.count : 1
    case 2:
      numRows = isShowingSort ? sort.count : 1
    case 3:
      numRows = 0
    default:
      numRows = 0
    }
    return numRows
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 22
  }
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let view  = view as? UITableViewHeaderFooterView {
      view.contentView.backgroundColor = BgColor
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var label = UILabel()
    label.frame = CGRectMake(2, 2, 320, 20)
    label.font = UIFont.boldSystemFontOfSize(16)
    label.text = self.tableView(tableView, titleForHeaderInSection: section)
    
    var headerView = UIView()
    headerView.addSubview(label)
    
    return headerView
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let text:String
    
    switch (section) {
    case 0:
      text = sections[0]
    case 1:
      text = sections[1]
    case 2:
      text = sections[2]
    case 3:
      text = sections[3]
    default:
      text = "Error"
    }
    
    return text

  }

  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch (indexPath.section) {
    case 1:
      if isShowingDistance {
        selectedDistanceIndex = indexPath.row
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! YelpSettingsCell
        FilterSettingsStore.sharedInstance.updateValueFor(cell.filterType, value: cell.filterValue)
      }
      isShowingDistance = !isShowingDistance
      tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    case 2:
      if isShowingSort {
        selectedSortIndex = indexPath.row
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! YelpSettingsCell
        FilterSettingsStore.sharedInstance.updateValueFor(cell.filterType, value: cell.filterValue)
      }
      isShowingSort = !isShowingSort
      tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    default:
      break
    }

  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("YelpSettingsCell") as! YelpSettingsCell;
    
    switch (indexPath.section) {
    case 0:
      var filterType = price[indexPath.row]["filter"] as? String
      cell.settingsLabel.text = price[indexPath.row]["label"] as? String
      cell.filterType = filterType
      if let checked = FilterSettingsStore.sharedInstance.getValueFor(filterType) as? Bool{
        cell.optionSwitch.on = checked
      }
      cell.delegate = self
      
    case 1:
      var filterType = "radius_filter"
      
      if isShowingDistance {
        cell.settingsLabel.text = distance[indexPath.row]["label"] as? String
        cell.filterValue = distance[indexPath.row]["value"] as? Int
        cell.accessoryType = indexPath.row == selectedDistanceIndex ? .Checkmark : .None
      }else{
        cell.settingsLabel.text = distance[selectedDistanceIndex]["label"] as? String
        cell.filterValue = distance[selectedDistanceIndex]["value"] as? Int
        cell.accessoryType = .DisclosureIndicator
      }
      
      cell.optionSwitch.hidden = true

      cell.filterType = filterType
      cell.delegate = self

    case 2:
      var filterType = "sort"
      
      if isShowingSort {
        cell.settingsLabel.text = sort[indexPath.row]["label"] as? String
        cell.filterValue = sort[indexPath.row]["value"] as? Int
        cell.accessoryType = indexPath.row == selectedSortIndex ? .Checkmark : .None
      }else{
        println("selected sort index: \(selectedSortIndex)")
        cell.settingsLabel.text = sort[selectedSortIndex]["label"] as? String
        cell.filterValue = sort[selectedSortIndex]["value"] as? Int
        cell.accessoryType = .DisclosureIndicator
      }
      
      cell.optionSwitch.hidden = true
      cell.filterType = filterType
      cell.delegate = self

    case 3:
      cell.settingsLabel.text = "Category"
      cell.filterType = "category"
      cell.delegate = self

    default:
      break
    }
    
    return cell
  }
  
  /*
  
  func setCellBorders(cell: UITableViewCell, indexPath: NSIndexPath){
    
    
    cell.layer.borderWidth = 0.0
    cell.layer.masksToBounds = true
    cell.separatorInset = UIEdgeInsetsZero
    //cell.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).CGColor
    
    var corners:UIRectCorner?
    let triggerCorners = isTop || isBottom
    
    if isTop && isBottom{
      corners = UIRectCorner.AllCorners
    }
    else if isBottom{
      corners = UIRectCorner.BottomLeft | UIRectCorner.BottomRight
    }
    else if isTop{
      corners = UIRectCorner.TopLeft | UIRectCorner.TopRight

    }
    
    if triggerCorners{
      let maskPath = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: corners!, cornerRadii: CGSize(width: 12.0, height: 12.0))
        
      let maskLayer = CAShapeLayer()
      maskLayer.frame = cell.bounds
      maskLayer.path = maskPath.CGPath
      cell.layer.mask = maskLayer
    }
    


  }
*/
  

  
}

// MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate{
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if let cell = cell as? YelpSettingsCell{
      let index = indexPath.row
      let isTop = index == 0
      var isBottom  = false
      
      switch (indexPath.section) {
      case 0:
        isBottom = index == price.count - 1
      case 1:
        isBottom = isShowingDistance ? index == distance.count - 1 : index == 0
      case 2:
        isBottom = isShowingSort ?  index == sort.count - 1 :  index == 0
      case 3:
        isBottom =  index == 0
      default:
        isBottom =  index == 0
      }
      
      cell.setBorders(isTop: isTop, isBottom: isBottom)
    }
  }
}

// MARK: - YelpSettingsCellDelegate
extension FilterViewController: YelpSettingsCellDelegate{
  func switchView(cell: YelpSettingsCell, switchedOn value: Bool) {
    println("\(cell.filterType) : \(value) ")
    FilterSettingsStore.sharedInstance.updateValueFor(cell.filterType, value: value)
  }
}
