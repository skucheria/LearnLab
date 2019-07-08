//
//  PushNotificationSender.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 7/7/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "uid"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAULYm_20:APA91bFDuFG1w5sH30TF8Zc5Lv2b8ALwhSl9Y1X2i3_c5IqFZMK4Au51aWE_pFAEY2WPEUg8Y4oIAd3Ldb7qVMwmxcxPvvkot4hY86r1qenYDYAq8cP-EBk0cgaLlemHFCgBnLJXrYFi", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
