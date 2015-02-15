//
//  Business.swft.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation
import GLKit

class Business : Deserializable{
  var title:String?
  var reviews:Int?
  var reviewsStatement:String?{
    let statement:String?
    if let reviews = reviews{
      statement = reviews != 1 ? "\(String(reviews)) reviews" : "\(String(reviews)) review"
    }else{
      statement = "No reviews"
    }
    return statement
  }
  var location:BusinessLocation?
  
  private var imageUrl:String?
  private var ratingImageUrl:String?
  private var userLatitude:Double?
  private var userLongitude:Double?
  private var categories:[[String]]?
  
  var ratingImageNsUrl:NSURL? {
    if let url = ratingImageUrl{
      return NSURL(string: url)
    }
    return nil
  }
  
  var imageNsUrl:NSURL? {
    if let url = imageUrl {
      return NSURL(string: url)
    }
    return nil
  }
  
  // The YelpAPI provides categories as a weird multidimensional array
  // of "pretty" names and code names.
  // This simply provides a comma-delimted list of the "pretty" names
  lazy var categoriesCommaDelimited:String? = {
    [unowned self] in
    var categoryStatement:String?
    
    if let categories = self.categories{
      var collection = [String]()
      for item in categories{
        if item.count > 0{
          collection.append(item[0])
        }
      }
      categoryStatement = ", ".join(collection)
    }
    return categoryStatement
    }()
  
  lazy var distanceTo:Double? = {
    [unowned self] in
    return self.location?.coordinate?.distanceTo(userLatitude: self.userLatitude, userLongitude:self.userLongitude)
  }()
  
  required init(data: [String: AnyObject]) {
    
    title <<< data["name"]
    imageUrl <<< data["image_url"]
    ratingImageUrl <<< data["rating_img_url"]
    reviews <<< data["review_count"]
    categories <<<* data["categories"]
    location <<<< data["location"]
    
  }
  
  func setUserLocation(#latitude: Double?, longitude: Double?){
    userLatitude = latitude
    userLongitude = longitude
  }
  
}

class BusinessLocation : Deserializable{
  var displayAddress: [String]?
  var singleDisplayAddress:String? {
    if let address = displayAddress{
      return ", ".join(address)
    }
    return nil
  }
  var coordinate:BusinessCoordinate?
  
  required init(data: [String: AnyObject]){
    displayAddress <<<* data["display_address"]
    coordinate <<<< data["coordinate"]
  }
}

class BusinessCoordinate : Deserializable{
  let MetersToMiles:Double = 0.000621371
  let R:Double = 6371000
  let DegreesToRadians:Double = 0.0174532925
  
  var latitude:Double?
  var longitude:Double?
  
  required init(data: [String: AnyObject]){
    latitude <<< data["latitude"]
    longitude <<< data["longitude"]
  }
  
  //Returns direct distance in miles
  func distanceTo(#userLatitude:Double?, userLongitude:Double?) -> Double?{
    if let latitude=latitude, let longitude=longitude, let userLatitude=userLatitude, let userLongitude=userLongitude{
      var φ1 = latitude * DegreesToRadians,
      φ2 = userLatitude * DegreesToRadians,
      Δλ = (userLongitude * DegreesToRadians) - (longitude * DegreesToRadians);
      
      var val = sin(φ1)*sin(φ2) + cos(φ1)*cos(φ2)*cos(Δλ)
      return acos(val) * R * MetersToMiles
    }
    return nil
  }
}

