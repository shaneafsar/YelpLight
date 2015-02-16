//
//  FilterSettingsStore.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation

class FilterSettingsStore{
  private let SortKey = "sort"
  private let DealsKey = "deals_filter"
  private let DistanceKey = "radius_filter"
  private let CategoryKey = "category_filter"
  private let lastEditDateKey = "last_edit_date"
  
  private let Defaults = NSUserDefaults.standardUserDefaults()
  
  // Cache Filter settings for 1 hr
  private let CacheAmountTimeInSeconds:Double = 3600
  
  private var Filters:[String] {
    return [SortKey, DealsKey, DistanceKey, CategoryKey]
  }
  
  //Singleton
  class var sharedInstance : FilterSettingsStore {
    struct Static {
      private static let bundle = NSBundle.mainBundle()
      static let instance : FilterSettingsStore = FilterSettingsStore()
    }
    if Static.instance.shouldClearValues {
      Static.instance.clearValues()
    }
    return Static.instance
  }
  
  private var lastEditDate: NSDate?{
    return Defaults.objectForKey(lastEditDateKey) as? NSDate
  }
  
  var shouldClearValues: Bool{
    if lastEditDate != nil{
      var timeSinceLastEdit = NSDate().timeIntervalSinceDate(lastEditDate!)
      return timeSinceLastEdit > CacheAmountTimeInSeconds
    }
    return false
  }
  
  var dealsFilter: Bool?{
    return getValueFor(DealsKey) as? Bool
  }
  
  var sortFilter: Int?{
    return getValueFor(SortKey) as? Int
  }
  
  var isSortByDistance:Bool{
    if let sort = sortFilter{
      return sort == 1
    }
    return false
  }
  
  var distanceFilter: Double?{
    return getValueFor(DistanceKey) as? Double
  }
  
  var categoryFilter: String?{
    return getValueFor(CategoryKey) as? String
  }
  
  var hasCategories: Bool{
    if let categoryFilter = categoryFilter{
      var currentValues = split(categoryFilter, {$0 == ","}, maxSplit: Int.max, allowEmptySlices: false)
      return currentValues.count > 0
    }
    return false
  }

  func getValueFor(key:String?) -> AnyObject?{
    if let key = key{
      return Defaults.objectForKey(key)
    }
    return nil
  }
  
  
  func updateValueFor(key:String?, value:AnyObject?){
    if let key = key{
      println("\(key): \(value)")
      Defaults.setValue(value, forKey: key)
      Defaults.synchronize();
    }
  }
  
  func updateValueForDeals(value: Bool?){
    updateValueFor(DealsKey, value: value)
  }
  
  func updateValueForDistance(value: Double?){
    if let value = value{
      Defaults.setDouble(value, forKey: DistanceKey)
      Defaults.synchronize();
    }
  }
  
  func updateValueForSort(value: Int?){
    updateValueFor(SortKey, value: value)
  }
  
  func updateValueForCategories(value: String?){
    if let categoryFilter = categoryFilter{
      if let value = value{
        toggleValues(categoryFilter, toggleValue: value)
      }
    }else{
      if let value = value{
        toggleValues("", toggleValue: value)
      }
    }
    
  }
  
  private func toggleValues(currentValue: String, toggleValue: String){
    var currentValues = split(currentValue, {$0 == ","}, maxSplit: Int.max, allowEmptySlices: false)
    if !contains(currentValues, toggleValue){
      currentValues.append(toggleValue)
      updateValueFor(CategoryKey, value: ",".join(currentValues))
    }else{
      currentValues.removeAtIndex(find(currentValues, toggleValue)!)
      updateValueFor(CategoryKey, value: ",".join(currentValues))
    }
  }

  func clearValues(){
    for filter in Filters{
      Defaults.setNilValueForKey(filter)
    }
  }
}