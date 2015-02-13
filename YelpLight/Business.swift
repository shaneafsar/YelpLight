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
    var distance:String?
    var imageUrl:String?
    var ratingImageUrl:String?
    var reviews:Int?
    var location:BusinessLocation?
    var userLocationLat:Double?
    var userLocationLon:Double?
    private var _categories:[[String]]?
    
    lazy var categoriesAsSingle:String? = {
        [unowned self] in
        var _cats:String?

        if let cats = self._categories{
            var _meta = [String]()
            for rry in cats{
                if rry.count > 0{
                    _meta.append(rry[0])
                }
            }
            _cats = ", ".join(_meta)
        }
        return _cats
    }()

    
    lazy var ratingImageNsUrl:NSURL? = {
       [unowned self] in
        if let url = self.ratingImageUrl{
            return NSURL(string: url)
        }
        return nil
    }()
    lazy var imageNsUrl:NSURL? = {
        [unowned self] in
        if let url = self.imageUrl {
            return NSURL(string: url)
        }
        return nil
    }()
    
    lazy var distanceTo:Double? = {
        [unowned self] in
        return self.location?.coordinate?.distanceTo(self.userLocationLat, long:self.userLocationLon)
    }()
    
    required init(data: [String: AnyObject]) {
        
        title <<< data["name"]
        distance <<< data["name"]
        imageUrl <<< data["image_url"]
        ratingImageUrl <<< data["rating_img_url"]
        reviews <<< data["review_count"]
        _categories <<<* data["categories"]
        location <<<< data["location"]
    
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
    let metersToMiles = 0.000621371 as Double
    let R = 6371000 as Double
    let degreesToRadians = 0.0174532925 as Double
    
    var latitude:Double?
    var longitude:Double?
    
    required init(data: [String: AnyObject]){
        latitude <<< data["latitude"]
        longitude <<< data["longitude"]
    }
    
    //Returns direct distance in miles
    func distanceTo(lat:Double?, long:Double?) -> Double?{
        if let lat1=latitude, let lon1=longitude, let lat2=lat, let lon2=long{
            var φ1 = lat1 * degreesToRadians,
                φ2 = lat2 * degreesToRadians,
            Δλ = (lon2 * degreesToRadians) - (lon1 * degreesToRadians);
        
            var val = sin(φ1)*sin(φ2) + cos(φ1)*cos(φ2)*cos(Δλ)
            return acos(val) * R * metersToMiles
        }
        return nil
    }
}

