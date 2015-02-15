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
  
  //Specifying explicit type to prevent Indexing issue
  var categories:Array<Dictionary<String,String>> = [["name" : "Afghan", "code": "afghani"]]
  
  //Singleton
  class var sharedInstance : YelpClient {
    struct Static {
      private static let bundle = NSBundle.mainBundle()
      static let instance : YelpClient = YelpClient(
        consumerKey: bundle.objectForInfoDictionaryKey("YELP_LIGHT_CONSUMER_KEY") as! String,
        consumerSecret: bundle.objectForInfoDictionaryKey("YELP_LIGHT_CONSUMER_SECRET") as! String,
        accessToken: bundle.objectForInfoDictionaryKey("YELP_LIGHT_ACCESS_TOKEN") as! String,
        accessSecret: bundle.objectForInfoDictionaryKey("YELP_LIGHT_ACCESS_SECRET") as! String
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
    
    initCategories()
  }
  
  
  
  func searchWithTerm(#term: String, location: String, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    var parameters = ["term": term, "location": location]
    return self.GET("search", parameters: parameters, success: success, failure: failure)
  }
  
  func searchWithTerm(#term: String, location: String, limit:Int, offset:Int, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
    
    let store = FilterSettingsStore.sharedInstance
    let radius = store.distanceFilter
    let deals = store.dealsFilter
    let sort = store.sortFilter
    
    return searchWithTerm(term: term, location: location, limit: limit, offset: offset, sort: sort, categoryFilter: nil, radiusFilter: radius , dealsFilter: deals, success: success, failure: failure)
  }
  
  func searchWithTerm(#term: String, location: String, limit: Int, offset:Int, sort:Int? = 0, categoryFilter: String?, radiusFilter: Double?, dealsFilter:Bool?, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
    
    var parameters:[String:String] = ["term": term, "location": location, "limit": String(limit), "offset": String(offset)]

    if let sort = sort{
       parameters.updateValue(String(stringInterpolationSegment: sort), forKey: "sort")
    }
    
    if let categoryFilter = categoryFilter{
      parameters.updateValue(categoryFilter, forKey: "category_filter")
    }
    if let radiusFilter = radiusFilter{
      if radiusFilter != 0 {
        parameters.updateValue(String(stringInterpolationSegment: radiusFilter), forKey: "radius_filter")
      }
    }
    if let dealsFilter = dealsFilter{
      parameters.updateValue(String(stringInterpolationSegment: dealsFilter), forKey: "deals_filter")
    }
    
    println("\(parameters)")

    return self.GET("search", parameters: parameters , success: success, failure: failure)
    
  }
  
  //
  //Doing this to get around Xcode's weird indexing issue
  //
  func initCategories(){
    categories.append(["name" : "African", "code": "african"])
    categories.append(["name" : "American, New", "code": "newamerican"])
    /*
    categories.append(["name" : "American, Traditional", "code": "tradamerican"])
    categories.append(["name" : "Arabian", "code": "arabian"])
    categories.append(["name" : "Argentine", "code": "argentine"])
    categories.append(["name" : "Armenian", "code": "armenian"])
    categories.append(["name" : "Asian Fusion", "code": "asianfusion"])
    categories.append(["name" : "Asturian", "code": "asturian"])
    categories.append(["name" : "Australian", "code": "australian"])
    categories.append(["name" : "Austrian", "code": "austrian"])
    categories.append(["name" : "Baguettes", "code": "baguettes"])
    categories.append(["name" : "Bangladeshi", "code": "bangladeshi"])
    categories.append(["name" : "Barbeque", "code": "bbq"])
    categories.append(["name" : "Basque", "code": "basque"])
    categories.append(["name" : "Bavarian", "code": "bavarian"])
    categories.append(["name" : "Beer Garden", "code": "beergarden"])
    categories.append(["name" : "Beer Hall", "code": "beerhall"])
    categories.append(["name" : "Beisl", "code": "beisl"])
    categories.append(["name" : "Belgian", "code": "belgian"])
    categories.append(["name" : "Bistros", "code": "bistros"])
    categories.append(["name" : "Black Sea", "code": "blacksea"])
    categories.append(["name" : "Brasseries", "code": "brasseries"])
    categories.append(["name" : "Brazilian", "code": "brazilian"])
    categories.append(["name" : "Breakfast & Brunch", "code": "breakfast_brunch"])
    categories.append(["name" : "British", "code": "british"])
    categories.append(["name" : "Buffets", "code": "buffets"])
    categories.append(["name" : "Bulgarian", "code": "bulgarian"])
    categories.append(["name" : "Burgers", "code": "burgers"])
    categories.append(["name" : "Burmese", "code": "burmese"])
    categories.append(["name" : "Cafes", "code": "cafes"])
    categories.append(["name" : "Cafeteria", "code": "cafeteria"])
    categories.append(["name" : "Cajun/Creole", "code": "cajun"])
    categories.append(["name" : "Cambodian", "code": "cambodian"])
    categories.append(["name" : "Canadian", "code": "New)"])
    categories.append(["name" : "Canteen", "code": "canteen"])
    categories.append(["name" : "Caribbean", "code": "caribbean"])
    categories.append(["name" : "Catalan", "code": "catalan"])
    categories.append(["name" : "Chech", "code": "chech"])
    categories.append(["name" : "Cheesesteaks", "code": "cheesesteaks"])
    categories.append(["name" : "Chicken Shop", "code": "chickenshop"])
    categories.append(["name" : "Chicken Wings", "code": "chicken_wings"])
    categories.append(["name" : "Chilean", "code": "chilean"])
    categories.append(["name" : "Chinese", "code": "chinese"])
    categories.append(["name" : "Comfort Food", "code": "comfortfood"])
    categories.append(["name" : "Corsican", "code": "corsican"])
    categories.append(["name" : "Creperies", "code": "creperies"])
    categories.append(["name" : "Cuban", "code": "cuban"])
    categories.append(["name" : "Curry Sausage", "code": "currysausage"])
    categories.append(["name" : "Cypriot", "code": "cypriot"])
    categories.append(["name" : "Czech", "code": "czech"])
    categories.append(["name" : "Czech/Slovakian", "code": "czechslovakian"])
    categories.append(["name" : "Danish", "code": "danish"])
    categories.append(["name" : "Delis", "code": "delis"])
    categories.append(["name" : "Diners", "code": "diners"])
    categories.append(["name" : "Dumplings", "code": "dumplings"])
    categories.append(["name" : "Eastern European", "code": "eastern_european"])
    categories.append(["name" : "Ethiopian", "code": "ethiopian"])
    categories.append(["name" : "Fast Food", "code": "hotdogs"])
    categories.append(["name" : "Filipino", "code": "filipino"])
    categories.append(["name" : "Fish & Chips", "code": "fishnchips"])
    categories.append(["name" : "Fondue", "code": "fondue"])
    categories.append(["name" : "Food Court", "code": "food_court"])
    categories.append(["name" : "Food Stands", "code": "foodstands"])
    categories.append(["name" : "French", "code": "french"])
    categories.append(["name" : "French Southwest", "code": "sud_ouest"])
    categories.append(["name" : "Galician", "code": "galician"])
    categories.append(["name" : "Gastropubs", "code": "gastropubs"])
    categories.append(["name" : "Georgian", "code": "georgian"])
    categories.append(["name" : "German", "code": "german"])
    categories.append(["name" : "Giblets", "code": "giblets"])
    categories.append(["name" : "Gluten-Free", "code": "gluten_free"])
    categories.append(["name" : "Greek", "code": "greek"])
    categories.append(["name" : "Halal", "code": "halal"])
    categories.append(["name" : "Hawaiian", "code": "hawaiian"])
    categories.append(["name" : "Heuriger", "code": "heuriger"])
    categories.append(["name" : "Himalayan/Nepalese", "code": "himalayan"])
    categories.append(["name" : "Hong Kong Style Cafe", "code": "hkcafe"])
    categories.append(["name" : "Hot Dogs", "code": "hotdog"])
    categories.append(["name" : "Hot Pot", "code": "hotpot"])
    categories.append(["name" : "Hungarian", "code": "hungarian"])
    categories.append(["name" : "Iberian", "code": "iberian"])
    categories.append(["name" : "Indian", "code": "indpak"])
    categories.append(["name" : "Indonesian", "code": "indonesian"])
    categories.append(["name" : "International", "code": "international"])
    categories.append(["name" : "Irish", "code": "irish"])
    categories.append(["name" : "Island Pub", "code": "island_pub"])
    categories.append(["name" : "Israeli", "code": "israeli"])
    categories.append(["name" : "Italian", "code": "italian"])
    categories.append(["name" : "Japanese", "code": "japanese"])
    categories.append(["name" : "Jewish", "code": "jewish"])
    categories.append(["name" : "Kebab", "code": "kebab"])
    categories.append(["name" : "Korean", "code": "korean"])
    categories.append(["name" : "Kosher", "code": "kosher"])
    categories.append(["name" : "Kurdish", "code": "kurdish"])
    categories.append(["name" : "Laos", "code": "laos"])
    categories.append(["name" : "Laotian", "code": "laotian"])
    categories.append(["name" : "Latin American", "code": "latin"])
    categories.append(["name" : "Live/Raw Food", "code": "raw_food"])
    categories.append(["name" : "Lyonnais", "code": "lyonnais"])
    categories.append(["name" : "Malaysian", "code": "malaysian"])
    categories.append(["name" : "Meatballs", "code": "meatballs"])
    categories.append(["name" : "Mediterranean", "code": "mediterranean"])
    categories.append(["name" : "Mexican", "code": "mexican"])
    categories.append(["name" : "Middle Eastern", "code": "mideastern"])
    categories.append(["name" : "Milk Bars", "code": "milkbars"])
    categories.append(["name" : "Modern Australian", "code": "modern_australian"])
    categories.append(["name" : "Modern European", "code": "modern_european"])
    categories.append(["name" : "Mongolian", "code": "mongolian"])
    categories.append(["name" : "Moroccan", "code": "moroccan"])
    categories.append(["name" : "New Zealand", "code": "newzealand"])
    categories.append(["name" : "Night Food", "code": "nightfood"])
    categories.append(["name" : "Norcinerie", "code": "norcinerie"])
    categories.append(["name" : "Open Sandwiches", "code": "opensandwiches"])
    categories.append(["name" : "Oriental", "code": "oriental"])
    categories.append(["name" : "Pakistani", "code": "pakistani"])
    categories.append(["name" : "Parent Cafes", "code": "eltern_cafes"])
    categories.append(["name" : "Parma", "code": "parma"])
    categories.append(["name" : "Persian/Iranian", "code": "persian"])
    categories.append(["name" : "Peruvian", "code": "peruvian"])
    categories.append(["name" : "Pita", "code": "pita"])
    categories.append(["name" : "Pizza", "code": "pizza"])
    categories.append(["name" : "Polish", "code": "polish"])
    categories.append(["name" : "Portuguese", "code": "portuguese"])
    categories.append(["name" : "Potatoes", "code": "potatoes"])
    categories.append(["name" : "Poutineries", "code": "poutineries"])
    categories.append(["name" : "Pub Food", "code": "pubfood"])
    categories.append(["name" : "Rice", "code": "riceshop"])
    categories.append(["name" : "Romanian", "code": "romanian"])
    categories.append(["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"])
    categories.append(["name" : "Rumanian", "code": "rumanian"])
    categories.append(["name" : "Russian", "code": "russian"])
    categories.append(["name" : "Salad", "code": "salad"])
    categories.append(["name" : "Sandwiches", "code": "sandwiches"])
    categories.append(["name" : "Scandinavian", "code": "scandinavian"])
    categories.append(["name" : "Scottish", "code": "scottish"])
    categories.append(["name" : "Seafood", "code": "seafood"])
    categories.append(["name" : "Serbo Croatian", "code": "serbocroatian"])
    categories.append(["name" : "Signature Cuisine", "code": "signature_cuisine"])
    categories.append(["name" : "Singaporean", "code": "singaporean"])
    categories.append(["name" : "Slovakian", "code": "slovakian"])
    categories.append(["name" : "Soul Food", "code": "soulfood"])
    categories.append(["name" : "Soup", "code": "soup"])
    categories.append(["name" : "Southern", "code": "southern"])
    categories.append(["name" : "Spanish", "code": "spanish"])
    categories.append(["name" : "Steakhouses", "code": "steak"])
    categories.append(["name" : "Sushi Bars", "code": "sushi"])
    categories.append(["name" : "Swabian", "code": "swabian"])
    categories.append(["name" : "Swedish", "code": "swedish"])
    categories.append(["name" : "Swiss Food", "code": "swissfood"])
    categories.append(["name" : "Tabernas", "code": "tabernas"])
    categories.append(["name" : "Taiwanese", "code": "taiwanese"])
    categories.append(["name" : "Tapas Bars", "code": "tapas"])
    categories.append(["name" : "Tapas/Small Plates", "code": "tapasmallplates"])
    categories.append(["name" : "Tex-Mex", "code": "tex-mex"])
    categories.append(["name" : "Thai", "code": "thai"])
    categories.append(["name" : "Traditional Norwegian", "code": "norwegian"])
    categories.append(["name" : "Traditional Swedish", "code": "traditional_swedish"])
    categories.append(["name" : "Trattorie", "code": "trattorie"])
    categories.append(["name" : "Turkish", "code": "turkish"])
    categories.append(["name" : "Ukrainian", "code": "ukrainian"])
    categories.append(["name" : "Uzbek", "code": "uzbek"])
    categories.append(["name" : "Vegan", "code": "vegan"])
    categories.append(["name" : "Vegetarian", "code": "vegetarian"])
    categories.append(["name" : "Venison", "code": "venison"])
    categories.append(["name" : "Vietnamese", "code": "vietnamese"])
    categories.append(["name" : "Wok", "code": "wok"])
    categories.append(["name" : "Wraps", "code": "wraps"])
    categories.append(["name" : "Yugoslav", "code": "yugoslav"])
    */
  }
  
}



/*
class YelpCategories{
let categories = [["name" : "Afghan", "code": "afghani"],
["name" : "African", "code": "african"],
["name" : "American, New", "code": "newamerican"],
["name" : "American, Traditional", "code": "tradamerican"],
["name" : "Arabian", "code": "arabian"],
["name" : "Argentine", "code": "argentine"],
["name" : "Armenian", "code": "armenian"],
["name" : "Asian Fusion", "code": "asianfusion"],
["name" : "Asturian", "code": "asturian"],
["name" : "Australian", "code": "australian"],
["name" : "Austrian", "code": "austrian"],
["name" : "Baguettes", "code": "baguettes"],
["name" : "Bangladeshi", "code": "bangladeshi"],
["name" : "Barbeque", "code": "bbq"],
["name" : "Basque", "code": "basque"],
["name" : "Bavarian", "code": "bavarian"],
["name" : "Beer Garden", "code": "beergarden"],
["name" : "Beer Hall", "code": "beerhall"],
["name" : "Beisl", "code": "beisl"],
["name" : "Belgian", "code": "belgian"],
["name" : "Bistros", "code": "bistros"],
["name" : "Black Sea", "code": "blacksea"],
["name" : "Brasseries", "code": "brasseries"],
["name" : "Brazilian", "code": "brazilian"],
["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
["name" : "British", "code": "british"],
["name" : "Buffets", "code": "buffets"],
["name" : "Bulgarian", "code": "bulgarian"],
["name" : "Burgers", "code": "burgers"],
["name" : "Burmese", "code": "burmese"],
["name" : "Cafes", "code": "cafes"],
["name" : "Cafeteria", "code": "cafeteria"],
["name" : "Cajun/Creole", "code": "cajun"],
["name" : "Cambodian", "code": "cambodian"],
["name" : "Canadian", "code": "New)"],
["name" : "Canteen", "code": "canteen"],
["name" : "Caribbean", "code": "caribbean"],
["name" : "Catalan", "code": "catalan"],
["name" : "Chech", "code": "chech"],
["name" : "Cheesesteaks", "code": "cheesesteaks"],
["name" : "Chicken Shop", "code": "chickenshop"],
["name" : "Chicken Wings", "code": "chicken_wings"],
["name" : "Chilean", "code": "chilean"],
["name" : "Chinese", "code": "chinese"],
["name" : "Comfort Food", "code": "comfortfood"],
["name" : "Corsican", "code": "corsican"],
["name" : "Creperies", "code": "creperies"],
["name" : "Cuban", "code": "cuban"],
["name" : "Curry Sausage", "code": "currysausage"],
["name" : "Cypriot", "code": "cypriot"],
["name" : "Czech", "code": "czech"],
["name" : "Czech/Slovakian", "code": "czechslovakian"],
["name" : "Danish", "code": "danish"],
["name" : "Delis", "code": "delis"],
["name" : "Diners", "code": "diners"],
["name" : "Dumplings", "code": "dumplings"],
["name" : "Eastern European", "code": "eastern_european"],
["name" : "Ethiopian", "code": "ethiopian"],
["name" : "Fast Food", "code": "hotdogs"],
["name" : "Filipino", "code": "filipino"],
["name" : "Fish & Chips", "code": "fishnchips"],
["name" : "Fondue", "code": "fondue"],
["name" : "Food Court", "code": "food_court"],
["name" : "Food Stands", "code": "foodstands"],
["name" : "French", "code": "french"],
["name" : "French Southwest", "code": "sud_ouest"],
["name" : "Galician", "code": "galician"],
["name" : "Gastropubs", "code": "gastropubs"],
["name" : "Georgian", "code": "georgian"],
["name" : "German", "code": "german"],
["name" : "Giblets", "code": "giblets"],
["name" : "Gluten-Free", "code": "gluten_free"],
["name" : "Greek", "code": "greek"],
["name" : "Halal", "code": "halal"],
["name" : "Hawaiian", "code": "hawaiian"],
["name" : "Heuriger", "code": "heuriger"],
["name" : "Himalayan/Nepalese", "code": "himalayan"],
["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
["name" : "Hot Dogs", "code": "hotdog"],
["name" : "Hot Pot", "code": "hotpot"],
["name" : "Hungarian", "code": "hungarian"],
["name" : "Iberian", "code": "iberian"],
["name" : "Indian", "code": "indpak"],
["name" : "Indonesian", "code": "indonesian"],
["name" : "International", "code": "international"],
["name" : "Irish", "code": "irish"],
["name" : "Island Pub", "code": "island_pub"],
["name" : "Israeli", "code": "israeli"],
["name" : "Italian", "code": "italian"],
["name" : "Japanese", "code": "japanese"],
["name" : "Jewish", "code": "jewish"],
["name" : "Kebab", "code": "kebab"],
["name" : "Korean", "code": "korean"],
["name" : "Kosher", "code": "kosher"],
["name" : "Kurdish", "code": "kurdish"],
["name" : "Laos", "code": "laos"],
["name" : "Laotian", "code": "laotian"],
["name" : "Latin American", "code": "latin"],
["name" : "Live/Raw Food", "code": "raw_food"],
["name" : "Lyonnais", "code": "lyonnais"],
["name" : "Malaysian", "code": "malaysian"],
["name" : "Meatballs", "code": "meatballs"],
["name" : "Mediterranean", "code": "mediterranean"],
["name" : "Mexican", "code": "mexican"],
["name" : "Middle Eastern", "code": "mideastern"],
["name" : "Milk Bars", "code": "milkbars"],
["name" : "Modern Australian", "code": "modern_australian"],
["name" : "Modern European", "code": "modern_european"],
["name" : "Mongolian", "code": "mongolian"],
["name" : "Moroccan", "code": "moroccan"],
["name" : "New Zealand", "code": "newzealand"],
["name" : "Night Food", "code": "nightfood"],
["name" : "Norcinerie", "code": "norcinerie"],
["name" : "Open Sandwiches", "code": "opensandwiches"],
["name" : "Oriental", "code": "oriental"],
["name" : "Pakistani", "code": "pakistani"],
["name" : "Parent Cafes", "code": "eltern_cafes"],
["name" : "Parma", "code": "parma"],
["name" : "Persian/Iranian", "code": "persian"],
["name" : "Peruvian", "code": "peruvian"],
["name" : "Pita", "code": "pita"],
["name" : "Pizza", "code": "pizza"],
["name" : "Polish", "code": "polish"],
["name" : "Portuguese", "code": "portuguese"],
["name" : "Potatoes", "code": "potatoes"],
["name" : "Poutineries", "code": "poutineries"],
["name" : "Pub Food", "code": "pubfood"],
["name" : "Rice", "code": "riceshop"],
["name" : "Romanian", "code": "romanian"],
["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
["name" : "Rumanian", "code": "rumanian"],
["name" : "Russian", "code": "russian"],
["name" : "Salad", "code": "salad"],
["name" : "Sandwiches", "code": "sandwiches"],
["name" : "Scandinavian", "code": "scandinavian"],
["name" : "Scottish", "code": "scottish"],
["name" : "Seafood", "code": "seafood"],
["name" : "Serbo Croatian", "code": "serbocroatian"],
["name" : "Signature Cuisine", "code": "signature_cuisine"],
["name" : "Singaporean", "code": "singaporean"],
["name" : "Slovakian", "code": "slovakian"],
["name" : "Soul Food", "code": "soulfood"],
["name" : "Soup", "code": "soup"],
["name" : "Southern", "code": "southern"],
["name" : "Spanish", "code": "spanish"],
["name" : "Steakhouses", "code": "steak"],
["name" : "Sushi Bars", "code": "sushi"],
["name" : "Swabian", "code": "swabian"],
["name" : "Swedish", "code": "swedish"],
["name" : "Swiss Food", "code": "swissfood"],
["name" : "Tabernas", "code": "tabernas"],
["name" : "Taiwanese", "code": "taiwanese"],
["name" : "Tapas Bars", "code": "tapas"],
["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
["name" : "Tex-Mex", "code": "tex-mex"],
["name" : "Thai", "code": "thai"],
["name" : "Traditional Norwegian", "code": "norwegian"],
["name" : "Traditional Swedish", "code": "traditional_swedish"],
["name" : "Trattorie", "code": "trattorie"],
["name" : "Turkish", "code": "turkish"],
["name" : "Ukrainian", "code": "ukrainian"],
["name" : "Uzbek", "code": "uzbek"],
["name" : "Vegan", "code": "vegan"],
["name" : "Vegetarian", "code": "vegetarian"],
["name" : "Venison", "code": "venison"],
["name" : "Vietnamese", "code": "vietnamese"],
["name" : "Wok", "code": "wok"],
["name" : "Wraps", "code": "wraps"],
["name" : "Yugoslav", "code": "yugoslav"]];
}
*/