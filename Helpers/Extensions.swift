//
//  Extensions.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/21/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

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

extension UIViewController{
    func getUserForUID(_ uid : String) -> User{
        let user = User()
        let ref = Database.database().reference()
        ref.child("user").observeSingleEvent(of: .value
            , with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : [String:Any]]{
                    for item in dictionary{
                        if(item.key == uid){
                            user.tutor = item.value["tutor"] as? String
                            user.email = item.value["email"] as? String
                            user.name = item.value["name"] as? String
                            user.profLinik = item.value["profilePic"] as? String
                            user.bio = item.value["bio"] as? String
                            user.courses = item.value["classes"] as? [String]
                            user.rating = item.value["rating"] as? NSNumber
                            user.id = item.key
                            user.rate = item.value["rate"] as? String
                            user.availability = item.value["availability"] as? String
                            user.fcmToken = item.value["fcmToken"] as? String
                            user.numReviews = item.value["numReviews"] as? Float
                            user.reviews = item.value["reviews"] as? [String]
                        }
                    }
                }
        })
        return user
    }
    
}

