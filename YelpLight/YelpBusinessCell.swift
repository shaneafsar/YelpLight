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

}
