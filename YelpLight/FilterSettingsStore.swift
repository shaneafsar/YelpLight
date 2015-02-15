//
//  FilterSettingsStore.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation

class FilterSettingsStore{
  private let alwaysRoundKey = "always_round_up"
  private let defaultTipKey = "default_tip_amount"
  private let lastEditDateKey = "last_edit_date"
  private let lastAmountKey = "last_amount"
  private let localeSettingKey = "locale_setting"
  private let themeSettingKey = "theme_setting"
  private var defaults = NSUserDefaults.standardUserDefaults()
  
  // It's set to a really small value for demo-purposes
  let cacheAmountTimeInSeconds = 5.0
  
  var alwaysRoundTips: Bool {
    return defaults.boolForKey(alwaysRoundKey)
  }
  
  var defaultTipAmount: Double {
    return defaults.doubleForKey(defaultTipKey)
  }
  
  var lastEditDate: NSDate?{
    return defaults.objectForKey(lastEditDateKey) as? NSDate
  }
  
  var shouldClearValues: Bool{
    if lastEditDate != nil{
      var timeSinceLastEdit = NSDate().timeIntervalSinceDate(lastEditDate!)
      return timeSinceLastEdit > cacheAmountTimeInSeconds
    }
    return false
  }
  
  var lastBillAmount: Double{
    return defaults.doubleForKey(lastAmountKey)
  }
  
  func setTipRounding(doRound: Bool){
    defaults.setBool(doRound, forKey: alwaysRoundKey)
    defaults.synchronize()
  }
  
  func setDefaultTip(amount: Double){
    defaults.setDouble(amount, forKey: defaultTipKey)
    defaults.synchronize()
  }
  
  func setLastEditTime(time: NSDate = NSDate()){
    defaults.setObject(time, forKey: lastEditDateKey)
    defaults.synchronize()
  }
  
  func setLastBillAmount(amount: Double){
    defaults.setDouble(amount, forKey: lastAmountKey)
    defaults.synchronize()
  }
  
  func setLocale(localId: String){
    defaults.setObject(localId, forKey: localeSettingKey);
    defaults.synchronize();
  }
  
  func setTheme(theme: String){
    defaults.setObject(theme, forKey: themeSettingKey);
    defaults.synchronize();
  }
  
  func clearValues(){
    setLastBillAmount(0)
  }
}