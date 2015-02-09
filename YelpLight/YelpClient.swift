//
//  YelpClient.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/8/15.
//  Taken from https://github.com/derrickshowers/RecommendIt
//  Singleton concept from https://github.com/alexnj/iOSTwitterSwift/blob/master/iOSTwitterSwift/TwitterClient.swift
//  Copyright (c) 2015 codepath. All rights reserved.
//

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    //Singleton
    class var sharedInstance : YelpClient {
        struct Static {
            private static let bundle = NSBundle.mainBundle()
            static let instance : YelpClient = YelpClient(
                consumerKey: bundle.objectForInfoDictionaryKey("YELP_LIGHT_CONSUMER_KEY") as NSString,
                consumerSecret: bundle.objectForInfoDictionaryKey("YELP_LIGHT_CONSUMER_SECRET") as NSString,
                accessToken: bundle.objectForInfoDictionaryKey("YELP_LIGHT_ACCESS_TOKEN") as NSString,
                accessSecret: bundle.objectForInfoDictionaryKey("YELP_LIGHT_ACCESS_SECRET") as NSString
            )
        }
        return Static.instance
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        var token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, location: String, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        var parameters = ["term": term, "location": location]
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
}