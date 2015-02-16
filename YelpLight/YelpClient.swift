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
  var categories:Array<Dictionary<String,String>> = [["label" : "Afghan", "value": "afghani"]]
  
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
    let categories = store.categoryFilter
    
    return searchWithTerm(term: term, location: location, limit: limit, offset: offset, sort: sort, categoryFilter: categories, radiusFilter: radius , dealsFilter: deals, success: success, failure: failure)
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
    //categories.append(["label" : "Afghan", "value": "afghani"])
    categories.append(["label" : "African", "value": "african"])
    categories.append(["label" : "American, New", "value": "newamerican"])
    categories.append(["label" : "American, Traditional", "value": "tradamerican"])
    categories.append(["label" : "Arabian", "value": "arabian"])
    categories.append(["label" : "Argentine", "value": "argentine"])
    categories.append(["label" : "Armenian", "value": "armenian"])
    categories.append(["label" : "Asian Fusion", "value": "asianfusion"])
    categories.append(["label" : "Asturian", "value": "asturian"])
    categories.append(["label" : "Australian", "value": "australian"])
    categories.append(["label" : "Austrian", "value": "austrian"])
    categories.append(["label" : "Baguettes", "value": "baguettes"])
    categories.append(["label" : "Bangladeshi", "value": "bangladeshi"])
    categories.append(["label" : "Barbeque", "value": "bbq"])
    categories.append(["label" : "Basque", "value": "basque"])
    categories.append(["label" : "Bavarian", "value": "bavarian"])
    categories.append(["label" : "Beer Garden", "value": "beergarden"])
    categories.append(["label" : "Beer Hall", "value": "beerhall"])
    categories.append(["label" : "Beisl", "value": "beisl"])
    categories.append(["label" : "Belgian", "value": "belgian"])
    categories.append(["label" : "Bistros", "value": "bistros"])
    categories.append(["label" : "Black Sea", "value": "blacksea"])
    categories.append(["label" : "Brasseries", "value": "brasseries"])
    categories.append(["label" : "Brazilian", "value": "brazilian"])
    categories.append(["label" : "Breakfast & Brunch", "value": "breakfast_brunch"])
    categories.append(["label" : "British", "value": "british"])
    categories.append(["label" : "Buffets", "value": "buffets"])
    categories.append(["label" : "Bulgarian", "value": "bulgarian"])
    categories.append(["label" : "Burgers", "value": "burgers"])
    categories.append(["label" : "Burmese", "value": "burmese"])
    categories.append(["label" : "Cafes", "value": "cafes"])
    categories.append(["label" : "Cafeteria", "value": "cafeteria"])
    categories.append(["label" : "Cajun/Creole", "value": "cajun"])
    categories.append(["label" : "Cambodian", "value": "cambodian"])
    categories.append(["label" : "Canadian", "value": "New)"])
    categories.append(["label" : "Canteen", "value": "canteen"])
    categories.append(["label" : "Caribbean", "value": "caribbean"])
    categories.append(["label" : "Catalan", "value": "catalan"])
    categories.append(["label" : "Chech", "value": "chech"])
    categories.append(["label" : "Cheesesteaks", "value": "cheesesteaks"])
    categories.append(["label" : "Chicken Shop", "value": "chickenshop"])
    categories.append(["label" : "Chicken Wings", "value": "chicken_wings"])
    categories.append(["label" : "Chilean", "value": "chilean"])
    categories.append(["label" : "Chinese", "value": "chinese"])
    categories.append(["label" : "Comfort Food", "value": "comfortfood"])
    categories.append(["label" : "Corsican", "value": "corsican"])
    categories.append(["label" : "Creperies", "value": "creperies"])
    categories.append(["label" : "Cuban", "value": "cuban"])
    categories.append(["label" : "Curry Sausage", "value": "currysausage"])
    categories.append(["label" : "Cypriot", "value": "cypriot"])
    categories.append(["label" : "Czech", "value": "czech"])
    categories.append(["label" : "Czech/Slovakian", "value": "czechslovakian"])
    categories.append(["label" : "Danish", "value": "danish"])
    categories.append(["label" : "Delis", "value": "delis"])
    categories.append(["label" : "Diners", "value": "diners"])
    categories.append(["label" : "Dumplings", "value": "dumplings"])
    categories.append(["label" : "Eastern European", "value": "eastern_european"])
    categories.append(["label" : "Ethiopian", "value": "ethiopian"])
    categories.append(["label" : "Fast Food", "value": "hotdogs"])
    categories.append(["label" : "Filipino", "value": "filipino"])
    categories.append(["label" : "Fish & Chips", "value": "fishnchips"])
    categories.append(["label" : "Fondue", "value": "fondue"])
    categories.append(["label" : "Food Court", "value": "food_court"])
    categories.append(["label" : "Food Stands", "value": "foodstands"])
    categories.append(["label" : "French", "value": "french"])
    categories.append(["label" : "French Southwest", "value": "sud_ouest"])
    categories.append(["label" : "Galician", "value": "galician"])
    categories.append(["label" : "Gastropubs", "value": "gastropubs"])
    categories.append(["label" : "Georgian", "value": "georgian"])
    categories.append(["label" : "German", "value": "german"])
    categories.append(["label" : "Giblets", "value": "giblets"])
    categories.append(["label" : "Gluten-Free", "value": "gluten_free"])
    categories.append(["label" : "Greek", "value": "greek"])
    categories.append(["label" : "Halal", "value": "halal"])
    categories.append(["label" : "Hawaiian", "value": "hawaiian"])
    categories.append(["label" : "Heuriger", "value": "heuriger"])
    categories.append(["label" : "Himalayan/Nepalese", "value": "himalayan"])
    categories.append(["label" : "Hong Kong Style Cafe", "value": "hkcafe"])
    categories.append(["label" : "Hot Dogs", "value": "hotdog"])
    categories.append(["label" : "Hot Pot", "value": "hotpot"])
    categories.append(["label" : "Hungarian", "value": "hungarian"])
    categories.append(["label" : "Iberian", "value": "iberian"])
    categories.append(["label" : "Indian", "value": "indpak"])
    categories.append(["label" : "Indonesian", "value": "indonesian"])
    categories.append(["label" : "International", "value": "international"])
    categories.append(["label" : "Irish", "value": "irish"])
    categories.append(["label" : "Island Pub", "value": "island_pub"])
    categories.append(["label" : "Israeli", "value": "israeli"])
    categories.append(["label" : "Italian", "value": "italian"])
    categories.append(["label" : "Japanese", "value": "japanese"])
    categories.append(["label" : "Jewish", "value": "jewish"])
    categories.append(["label" : "Kebab", "value": "kebab"])
    categories.append(["label" : "Korean", "value": "korean"])
    categories.append(["label" : "Kosher", "value": "kosher"])
    categories.append(["label" : "Kurdish", "value": "kurdish"])
    categories.append(["label" : "Laos", "value": "laos"])
    categories.append(["label" : "Laotian", "value": "laotian"])
    categories.append(["label" : "Latin American", "value": "latin"])
    categories.append(["label" : "Live/Raw Food", "value": "raw_food"])
    categories.append(["label" : "Lyonnais", "value": "lyonnais"])
    categories.append(["label" : "Malaysian", "value": "malaysian"])
    categories.append(["label" : "Meatballs", "value": "meatballs"])
    categories.append(["label" : "Mediterranean", "value": "mediterranean"])
    categories.append(["label" : "Mexican", "value": "mexican"])
    categories.append(["label" : "Middle Eastern", "value": "mideastern"])
    categories.append(["label" : "Milk Bars", "value": "milkbars"])
    categories.append(["label" : "Modern Australian", "value": "modern_australian"])
    categories.append(["label" : "Modern European", "value": "modern_european"])
    categories.append(["label" : "Mongolian", "value": "mongolian"])
    categories.append(["label" : "Moroccan", "value": "moroccan"])
    categories.append(["label" : "New Zealand", "value": "newzealand"])
    categories.append(["label" : "Night Food", "value": "nightfood"])
    categories.append(["label" : "Norcinerie", "value": "norcinerie"])
    categories.append(["label" : "Open Sandwiches", "value": "opensandwiches"])
    categories.append(["label" : "Oriental", "value": "oriental"])
    categories.append(["label" : "Pakistani", "value": "pakistani"])
    categories.append(["label" : "Parent Cafes", "value": "eltern_cafes"])
    categories.append(["label" : "Parma", "value": "parma"])
    categories.append(["label" : "Persian/Iranian", "value": "persian"])
    categories.append(["label" : "Peruvian", "value": "peruvian"])
    categories.append(["label" : "Pita", "value": "pita"])
    categories.append(["label" : "Pizza", "value": "pizza"])
    categories.append(["label" : "Polish", "value": "polish"])
    categories.append(["label" : "Portuguese", "value": "portuguese"])
    categories.append(["label" : "Potatoes", "value": "potatoes"])
    categories.append(["label" : "Poutineries", "value": "poutineries"])
    categories.append(["label" : "Pub Food", "value": "pubfood"])
    categories.append(["label" : "Rice", "value": "riceshop"])
    categories.append(["label" : "Romanian", "value": "romanian"])
    categories.append(["label" : "Rotisserie Chicken", "value": "rotisserie_chicken"])
    categories.append(["label" : "Rumanian", "value": "rumanian"])
    categories.append(["label" : "Russian", "value": "russian"])
    categories.append(["label" : "Salad", "value": "salad"])
    categories.append(["label" : "Sandwiches", "value": "sandwiches"])
    categories.append(["label" : "Scandinavian", "value": "scandinavian"])
    categories.append(["label" : "Scottish", "value": "scottish"])
    categories.append(["label" : "Seafood", "value": "seafood"])
    categories.append(["label" : "Serbo Croatian", "value": "serbocroatian"])
    categories.append(["label" : "Signature Cuisine", "value": "signature_cuisine"])
    categories.append(["label" : "Singaporean", "value": "singaporean"])
    categories.append(["label" : "Slovakian", "value": "slovakian"])
    categories.append(["label" : "Soul Food", "value": "soulfood"])
    categories.append(["label" : "Soup", "value": "soup"])
    categories.append(["label" : "Southern", "value": "southern"])
    categories.append(["label" : "Spanish", "value": "spanish"])
    categories.append(["label" : "Steakhouses", "value": "steak"])
    categories.append(["label" : "Sushi Bars", "value": "sushi"])
    categories.append(["label" : "Swabian", "value": "swabian"])
    categories.append(["label" : "Swedish", "value": "swedish"])
    categories.append(["label" : "Swiss Food", "value": "swissfood"])
    categories.append(["label" : "Tabernas", "value": "tabernas"])
    categories.append(["label" : "Taiwanese", "value": "taiwanese"])
    categories.append(["label" : "Tapas Bars", "value": "tapas"])
    categories.append(["label" : "Tapas/Small Plates", "value": "tapasmallplates"])
    categories.append(["label" : "Tex-Mex", "value": "tex-mex"])
    categories.append(["label" : "Thai", "value": "thai"])
    categories.append(["label" : "Traditional Norwegian", "value": "norwegian"])
    categories.append(["label" : "Traditional Swedish", "value": "traditional_swedish"])
    categories.append(["label" : "Trattorie", "value": "trattorie"])
    categories.append(["label" : "Turkish", "value": "turkish"])
    categories.append(["label" : "Ukrainian", "value": "ukrainian"])
    categories.append(["label" : "Uzbek", "value": "uzbek"])
    categories.append(["label" : "Vegan", "value": "vegan"])
    categories.append(["label" : "Vegetarian", "value": "vegetarian"])
    categories.append(["label" : "Venison", "value": "venison"])
    categories.append(["label" : "Vietnamese", "value": "vietnamese"])
    categories.append(["label" : "Wok", "value": "wok"])
    categories.append(["label" : "Wraps", "value": "wraps"])
    categories.append(["label" : "Yugoslav", "value": "yugoslav"])
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