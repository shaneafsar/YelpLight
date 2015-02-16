//
//  FilterViewController.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/9/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

protocol SearchDelegate {
  func refreshSearch()
}


class FilterViewController: UIViewController {
  
  let BgColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
  
  @IBOutlet weak var searchButton: UIBarButtonItem!
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
  
  var delegate: SearchDelegate!

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
  
  var categories:[[String:String]] = YelpClient.sharedInstance.categories
  
  var isShowingDistance = false
  var selectedDistanceIndex = 0
  
  var isShowingSort = false
  var selectedSortIndex = 0
  
  var isShowingCategories = false
  var selectedCategoriesIndices:[Int] = []
  
  var previousDealsFilter:Bool? = FilterSettingsStore.sharedInstance.dealsFilter
  var previousDistanceFilter:Double? = FilterSettingsStore.sharedInstance.distanceFilter
  var previousSortFilter:Int? = FilterSettingsStore.sharedInstance.sortFilter
  var previousCategoryFilter:String? = FilterSettingsStore.sharedInstance.categoryFilter
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setIndices()
    setTableView()
  }
  
  private func setIndices(){
    let store = FilterSettingsStore.sharedInstance
    
    selectedDistanceIndex = findIndexFor(distance, value: store.distanceFilter)
    
    selectedSortIndex = findIndexFor(sort, value: store.sortFilter)
    
    selectedCategoriesIndices = findIndicesFor(categories, value: store.categoryFilter)

  }
  
  
  @IBAction func onCancelPress(sender: AnyObject) {
    let store = FilterSettingsStore.sharedInstance
    
    store.updateValueForDeals(previousDealsFilter)
    
    store.updateValueForDistance(previousDistanceFilter)
    
    store.updateValueForSort(previousSortFilter)
    
    store.updateValueForCategories(previousCategoryFilter)

    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func onSearchPress(sender: AnyObject) {
    delegate.refreshSearch()
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func findIndexFor(filters: [[String:AnyObject?]], value:Double?) -> Int{
    if let value = value{
      println("FindIndexDouble for: \(value) in \(filters)")
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
  
  func findIndicesFor(filters: [[String:String]], value:String?) -> [Int]{
    let blank:[Int] = []
    if let value = value{
      var indices:[Int] = []
      println("FindIndices for: \(value)")
      var selectedValues = split(value, {$0 == ","}, maxSplit: Int.max, allowEmptySlices: false)
      for var index = 0 ; index < filters.count; ++index {
        if let defaultValue = filters[index]["value"]{
          if contains(selectedValues, defaultValue) {
            indices.append(index)
          }
        }
      }
      return indices.count > 0 ? indices : blank
    }
    return blank
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setTableView(){
    tableView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
    
    view.backgroundColor = BgColor
    tableView.backgroundColor = BgColor

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
      numRows = isShowingCategories ? categories.count : 1
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
    let section = indexPath.section
    let store = FilterSettingsStore.sharedInstance
    var cell = tableView.cellForRowAtIndexPath(indexPath) as! YelpSettingsCell
    
    switch (section) {
    case 1:
      if isShowingDistance {
        selectedDistanceIndex = indexPath.row
        store.updateValueForDistance(distance[indexPath.row]["value"] as? Double)
      }
      isShowingDistance = !isShowingDistance
      tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Fade)
    case 2:
      if isShowingSort {
        selectedSortIndex = indexPath.row
        store.updateValueForSort(sort[indexPath.row]["value"] as? Int)
      }
      isShowingSort = !isShowingSort
      tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Fade)
    case 3:
      if isShowingCategories {
        let isSelected = contains(selectedCategoriesIndices, indexPath.row)
        
        if isSelected {
          selectedCategoriesIndices.removeAtIndex(find(selectedCategoriesIndices, indexPath.row)!)
        }else{
          selectedCategoriesIndices.append(indexPath.row)
        }
        
        cell.accessoryType = isSelected ? .None : .Checkmark
        //cell.accessoryView = CircleView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), isSelected: !isSelected)
        
        println("Toggle Category: \(cell.filterValue as? String)")
        store.updateValueForCategories(cell.filterValue as? String)
        println("Current categories: \(store.categoryFilter)")
      }else{
        isShowingCategories = true
        tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Fade)
      }
    default:

      break
    }

  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("YelpSettingsCell", forIndexPath:indexPath) as! YelpSettingsCell;

    switch (indexPath.section) {
    case 0:
      var filterType = price[indexPath.row]["filter"] as? String
      cell.settingsLabel.text = price[indexPath.row]["label"] as? String
      cell.filterType = filterType
      if let checked = FilterSettingsStore.sharedInstance.getValueFor(filterType) as? Bool{
        cell.optionSwitch.on = checked
      }
      cell.optionSwitch.hidden = false
      cell.delegate = self
      
    case 1:
      var filterType = "radius_filter"
      
      if isShowingDistance {
        cell.settingsLabel.text = distance[indexPath.row]["label"] as? String
        cell.filterValue = distance[indexPath.row]["value"] as? Int
        cell.accessoryType = indexPath.row == selectedDistanceIndex ? .Checkmark : .None
      }else{
        println("selected distance index: \(selectedDistanceIndex)")
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
      var filterType = "category_filter"
      println("selected categories indices: \(selectedCategoriesIndices)")
      
      if isShowingCategories {
        let isSelected = contains(selectedCategoriesIndices, indexPath.row)
        cell.settingsLabel.text = categories[indexPath.row]["label"]
        cell.filterValue =  categories[indexPath.row]["value"]
        cell.accessoryType = isSelected ? .Checkmark : .None
        //cell.accessoryType = .None
        //cell.accessoryView = CircleView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), isSelected: isSelected)
      }else{
        cell.settingsLabel.text = "Show all categories"
        cell.filterValue = nil
        cell.accessoryType = .DisclosureIndicator
      }

      
      cell.optionSwitch.hidden = true
      cell.selectionStyle = .None
      cell.selectedBackgroundView = UIView()
      cell.selectedBackgroundView.backgroundColor = UIColor.clearColor()
      cell.filterType = filterType
      cell.delegate = self

    default:
      break
    }
    
    updateCellView(cell, indexPath: indexPath)
    
    return cell
  }

  
}

// MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate{
  func updateCellView(cell: UITableViewCell, indexPath: NSIndexPath){
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
        isBottom = isShowingCategories ? index == categories.count - 1 : index == 0
      default:
        isBottom =  index == 0
      }
      
      println("\(isBottom), isTop: \(isTop)")
      cell.setBorders(isTop: isTop, isBottom: isBottom)
    }
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    updateCellView(cell, indexPath: indexPath)
  }
  
  //Custom masks don't automatically resize on orientation change
  //so this is needed
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let visibleCells = tableView.visibleCells() as? [YelpSettingsCell]
    if let visibleCells  = visibleCells {
      for cell in visibleCells {
        if let indexPath = tableView.indexPathForCell(cell){
          println("\(indexPath.section), \(indexPath.row)")
          updateCellView(cell, indexPath: indexPath)
        }
        cell.layoutSubviews()
      }
    }
    
  }
  
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    viewWillLayoutSubviews()
  }
}

// MARK: - YelpSettingsCellDelegate
extension FilterViewController: YelpSettingsCellDelegate{
  func switchView(cell: YelpSettingsCell, switchedOn value: Bool) {
    println("\(cell.filterType) : \(value) ")
    FilterSettingsStore.sharedInstance.updateValueFor(cell.filterType, value: value)
  }
}
