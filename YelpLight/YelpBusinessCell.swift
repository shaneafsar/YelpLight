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
    
    func setProperties(business:Business){
        bizTitle.text = business.title
        bizDistance.text = "0.1 mi"
        bizImage.setImageWithURL(business.imageNsUrl)
        bizRatingImage.setImageWithURL(business.ratingImageNsUrl)
    }
    
    func setProperties(business:Business, number:Int){
        setProperties(business)
        if let title = business.title {
            bizTitle.text = "\(String(number)). \(title)"
        }
    }

}