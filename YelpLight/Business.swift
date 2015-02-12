//
//  Business.swft.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation

class Business : Deserializable{
    var title:String?
    var distance:String?
    var imageUrl:String?
    var ratingImageUrl:String?
    var reviews:Int?
    var address:String?
    var categories:String?
    var location:BusinessLocation?
    
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
    
    required init(data: [String: AnyObject]) {
        title <<< data["name"]
        distance <<< data["name"]
        imageUrl <<< data["image_url"]
        ratingImageUrl <<< data["rating_image_url"]
        reviews <<< data["review_count"]
        address <<< data["address"]
        categories <<< data["categories"]
        location <<<< data["location"]
    }
    
}

class BusinessLocation : Deserializable{
    var displayAddress: [String]?
    
    required init(data: [String: AnyObject]){
        displayAddress <<<* data["display_address"]
    }
}
