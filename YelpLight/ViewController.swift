//
//  ViewController.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/8/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
  
  private let InfiniteScrollThreshold = 10
  private let ResultLimit = 20
  private let DefaultText = "Restaurants"
  private var searchLocation = "San Francisco"
  private let LocManager = CLLocationManager()
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var filterButton: UIBarButtonItem!
  
  @IBOutlet weak var searchInput: UISearchBar!
  
  private var latitude:Double?
  private var longitude:Double?
  private var currentSearchText:String?
  private var Businesses:[Business]?
  private var totalBusinesses:Int?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    //Move the searchinput to the navbar
    navigationItem.titleView = searchInput
  }
  
  override func viewWillDisappear(animated:Bool) {
    super.viewWillDisappear(animated)
    
    //Close the keyboard if transitioning to a new view
    searchInput.endEditing(true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /*
    make outlets "Strong" references
    UIView.transitionFromView(self.businessMap, toView: self.businessTable, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: { (animationFlag:Bool) -> Void in
    self.businessTable.reloadData()})
    UIViewAnimationOptions.TransitionFlipFromLeft | UIViewAnimationOptions.ShowHideTransitionViews
    */
    
    setNavView()
    setTableView()
    setLocation()
    getBusinessResults(DefaultText, offset: 0)
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setNavView(){
    searchInput.text = DefaultText
    searchInput.delegate = self
    filterButton.title = "Filter"
  }
  
  private func setTableView(){
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    // Need to set estimated height to *something* to allow height Automatic Dimension
    // to take place.
    tableView.estimatedRowHeight = 100
    tableView.tableFooterView = UIView(frame:CGRectZero)

  }

  
  private func setLocation(){
    LocManager.delegate = self
    LocManager.distanceFilter = kCLDistanceFilterNone
    LocManager.desiredAccuracy = kCLLocationAccuracyBest
    LocManager.requestWhenInUseAuthorization()
    LocManager.startUpdatingLocation()

    updateLocation()
  }
  
  private func updateLocation(){
    if(CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse && LocManager.location != nil){
      latitude = LocManager.location.coordinate.latitude
      longitude = LocManager.location.coordinate.longitude
    }
  }
  
  private func getBusinessResultsTest(){
    Businesses = [
      Business(data: ["name":"Yelp long name"]),
      Business(data: ["name":"Yelp again okay, let's hope this wraps to the next line"]),
      Business(data: ["name":"In-N-Out"])
    ]
  }
  

  private func getBusinessResultsSuccess(#operation: AFHTTPRequestOperation!, response: AnyObject!, isFreshSearch: Bool) -> Void {
    var moreBusinesses:[Business]?
    
    moreBusinesses <<<<* response["businesses"]
    totalBusinesses <<< response["total"]
    
    //Loop through and add user location to models.
    //also add models if this is a pagination request
    if let businesses = moreBusinesses {
      for business in businesses {
        business.setUserLocation(latitude: self.latitude, longitude: self.longitude)
        
        if !isFreshSearch {
          Businesses?.append(business)
        }
      }
    
    }
    
    //Set models if this is a fresh request
    if isFreshSearch{
      Businesses = moreBusinesses
    }
    
    //Since the Yelp API doesn't return the distance, and the calculation
    //we are using to get the distance is slightly different, we need to manually sort
    //if it's done by "distance"
    if let sort = FilterSettingsStore.sharedInstance.getValueFor("sort") as? Int, let Businesses = Businesses{
      if sort == 1{
        self.Businesses = sorted(Businesses){(biz1, biz2) -> Bool in
          return biz1.distanceTo < biz2.distanceTo
        }

      }
    }
    
    tableView.reloadData()
    
    //scroll to top if new search
    if isFreshSearch{
      tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
    }

  }
  
  func refreshBusinessResults(){
    getBusinessResults(currentSearchText ?? DefaultText, offset: 0)
  }
  
  private func getBusinessResults(searchTerm: String, offset:Int) -> Void {
    let isFreshSearch = offset == 0
    
    updateLocation()
    
    YelpClient.sharedInstance.searchWithTerm(
      term: searchTerm,
      location: searchLocation,
      limit: ResultLimit,
      offset: offset,
      success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        self.getBusinessResultsSuccess(operation: operation, response: response, isFreshSearch: isFreshSearch)
      },
      failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        println(error)
        println("Dang, getBusinessResults failed!!")
    })
  }
  
  
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate{
  
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    println("Authorization status changed")
    updateLocation()
  }
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    println("Did update locations")
    var currentLocation = locations[0] as? CLLocation
    LocManager.stopUpdatingLocation()
    var GeoCoder = CLGeocoder()
    GeoCoder.reverseGeocodeLocation(currentLocation){ (placemarks, error) -> Void in
      if error != nil{
        println("failed to get location: \(error)")
      }else{
        var placemark = placemarks[0] as? CLPlacemark
        println("Location found")
        if let addressLines = placemark?.addressDictionary["FormattedAddressLines"] as? [String]{
          self.searchLocation = ",".join(addressLines)
        }
      }
    }
  }
  
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate{

}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource{
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Businesses?.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("YelpBusinessCell") as! YelpBusinessCell
    
    if let Businesses = Businesses{
      var index = indexPath.row
      cell.setProperties(Businesses[index], number: index+1)
    }
    cell.backgroundColor = UIColor.clearColor()
    cell.sizeToFit()
    return cell
  }
  
  //Infinite scroll functionality
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
    if let Businesses = Businesses, let totalBusinesses = totalBusinesses, currentSearchText = currentSearchText{
      if indexPath.row == Businesses.count - InfiniteScrollThreshold && Businesses.count != totalBusinesses{
        getBusinessResults(currentSearchText, offset: Businesses.count)
      }
    }
  }

}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate{
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    
    if !searchText.isEmpty {
      currentSearchText = searchText
      Businesses = nil
      getBusinessResults(searchText, offset: 0)
    }
  }
  
}

