//
//  Extensions.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

extension UIImageView{
    
    func setFadeImageWithUrl(url: NSURL!){
        self.setFadeImageWithUrl(url, success: {})
    }
    
    func setFadeImageWithUrl(url: NSURL!, success: () -> Void){
        let fadeTime = 0.25
        self.alpha = 0
        if(url != nil){
            var urlRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10)
        
            self.setImageWithURLRequest(
            urlRequest,
            placeholderImage: UIImage(named: "placeholder"),
            success: {(urlRequest:NSURLRequest!, urlResponse:NSHTTPURLResponse!, image:UIImage!) in
                self.image = image
                UIView.animateWithDuration(fadeTime) {
                    self.alpha = 1
                }
                NSLog("loaded!")
                success()
            },
            failure: {(urlRequest:NSURLRequest!, urlResponse:NSHTTPURLResponse!, error:NSError!) in
                UIView.animateWithDuration(fadeTime) {
                    self.alpha = 1
                }
                NSLog("failed!")
            })
        }
    }
    
}
