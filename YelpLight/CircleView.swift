//
//  CircleView.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//


class CircleView: UIButton {
  
  init(frame: CGRect, isSelected:Bool){
    super.init(frame: frame)
    if isSelected{
      backgroundColor = UIColor(CIColor: CIColor(red: 0, green: 0.48, blue: 1, alpha: 1))
    }else{
      backgroundColor = UIColor.clearColor()
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func drawRect(rect: CGRect)
  {
    var context = UIGraphicsGetCurrentContext();
    
    // Set the circle outerline-width
    CGContextSetLineWidth(context, 1.0);
    
    // Set the circle outerline-colour
    UIColor.lightGrayColor().set()
    
    // Create Circle
    CGContextAddArc(context, (frame.size.width)/2, frame.size.height/2, (frame.size.width - 10)/2, 0.0, CGFloat(M_PI * 2.0), 1)
    
    // Draw
    CGContextStrokePath(context);
    
  }

}
