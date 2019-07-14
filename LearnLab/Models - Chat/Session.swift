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
//    var duration : NSNumber?
    var active : String?
    var declined : String?
    var sessionID: String?
    var endTime : NSNumber?
}


// TODO: write global function to retrieve user data given userID
