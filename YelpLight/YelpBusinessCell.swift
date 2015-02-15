//
//  YelpBusinessCell.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/9/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class YelpBusinessCell: UITableViewCell {
  
  @IBOutlet weak var bizImage: UIImageView!
  
  @IBOutlet weak var bizDistance: UILabel!
  
  @IBOutlet weak var bizTitle: UILabel!
  
  @IBOutlet weak var bizRatingImage: UIImageView!
  
  @IBOutlet weak var bizAddress: UILabel!
  
  @IBOutlet weak var bizCategory: UILabel!
  
  @IBOutlet weak var bizReviewCount: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  private func getFormattedMilesFrom(business:Business) -> String?{
    var formatted:String? = nil
    if let distanceTo = business.distanceTo{
      formatted = NSString(format: "%.2f mi", distanceTo) as String?
    }
    return formatted
  }
  
  func setProperties(business:Business){
    bizTitle.text = business.title
    bizDistance.text = getFormattedMilesFrom(business)
    bizImage.setImageWithURL(business.imageNsUrl)
    bizImage.backgroundColor = UIColor.clearColor()
    bizRatingImage.setImageWithURL(business.ratingImageNsUrl)
    bizRatingImage.backgroundColor = UIColor.clearColor()
    bizAddress.text = business.location?.singleDisplayAddress
    bizCategory.text = business.categoriesCommaDelimited
    bizReviewCount.text = business.reviewsStatement
  }
  
  func setProperties(business:Business, number:Int){
    setProperties(business)
    if let title = business.title {
      bizTitle.text = "\(String(number)). \(title)"
    }
  }
  
}
