//
//  FilterSettingsStore.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation

class FilterSettingsStore{
  private let DealsOnlyKey = "deals_only"
  private let defaultTipKey = "default_tip_amount"
  private let lastEditDateKey = "last_edit_date"
  private let lastAmountKey = "last_amount"
  private let localeSettingKey = "locale_setting"
  private let themeSettingKey = "theme_setting"
  private let Defaults = NSUserDefaults.standardUserDefaults()
  
  // It's set to a really small value for demo-purposes
  private let CacheAmountTimeInSeconds:Double = 3600
  
  private let Filters:[String] = ["deals_filter", "sort", "radius_filter", "category_filter"]
  
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
    return getValueFor("deals_filter") as? Bool
  }
  
  var sortFilter: Int?{
    return getValueFor("sort") as? Int
  }
  
  var distanceFilter: Double?{
    return getValueFor("radius_filter") as? Double
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
    updateValueFor("deals_filter", value: value)
  }
  
  func updateValueForDistance(value: Double?){
    updateValueFor("radius_filter", value: value)
  }
  
  func updateValueForCategories(value: String?){
    
  }
  
  
  func clearValues(){
    for filter in Filters{
      Defaults.setNilValueForKey(filter)
    }
  }
}