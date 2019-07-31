//
//  Course.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/2/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

@objcMembers
class Session: NSObject {
    var tutorID: String?
    var studentID: String?
    var startTime : NSNumber?
    var active : String?
    var declined : String?
    var sessionID: String?
    var endTime : NSNumber?  // the actual duration of the session
    var reviewed : Float?
    var long : NSNumber?
    var lat : NSNumber?
}


// TODO: write global function to retrieve user data given userID
