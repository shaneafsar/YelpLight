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
        
        //bizTitle.sizeToFit()
        //self.contentView.sizeToFit()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getMilesString(business:Business) -> String?{
        var s:String? = nil
        if let f = business.distanceTo{
            s = NSString(format: "%.2f mi", f) as String?
        }
        return s
    }
    
    func setProperties(business:Business){
        bizTitle.text = business.title
        bizDistance.text = getMilesString(business)
        bizImage.setImageWithURL(business.imageNsUrl)
        bizImage.backgroundColor = UIColor.clearColor()
        bizRatingImage.setImageWithURL(business.ratingImageNsUrl)
        bizRatingImage.backgroundColor = UIColor.clearColor()
        bizAddress.text = business.location?.singleDisplayAddress
        bizCategory.text = business.categoriesAsSingle
        if let count = business.reviews{
            if count != 1{
                bizReviewCount.text = "\(String(count)) reviews"
            }else{
                bizReviewCount.text = "\(String(count)) review"
            }
        }else{
            bizReviewCount.text = "No reviews"
        }
        
    }
    
    func setProperties(business:Business, number:Int){
        setProperties(business)
        if let title = business.title {
            bizTitle.text = "\(String(number)). \(title)"
        }
    }

}
