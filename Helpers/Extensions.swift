//
//  Extensions.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/21/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadImageUsingCacheWithUrlString(urlString: String){
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject){
            self.image = cachedImage as! UIImage
            return
        }
        
//        if let profileImageUrl = urlString{
            let url = URL(string: urlString)
        
            
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                if error != nil{
                    print(error)
                    return
                }
                
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        self.image = downloadedImage
                    }
                    
//                    self.image = UIImage(data: data!)
                }
            }).resume()
//        }
    }
    
}
