//
//  YelpLightCell.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/9/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

protocol YelpSettingsCellDelegate : class{
  func switchView(cell:YelpSettingsCell, switchedOn value:Bool)
}

class YelpSettingsCell: UITableViewCell {
  
  weak var delegate:YelpSettingsCellDelegate?
  
  @IBOutlet weak var optionSwitch: UISwitch!
  
  @IBOutlet weak var settingsLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func onChange(cell:YelpSettingsCell, value:Bool){
    optionSwitch.on = value
  }
  
}
