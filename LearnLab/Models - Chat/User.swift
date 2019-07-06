//
//  User.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/16/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

@objcMembers
class User: NSObject {
    var email: String?
    var name: String?
    var profLinik : String?
    var id : String?
    var tutor : String?
    var bio : String?
    var courses : [String]?
    var rating : NSNumber?
    var reviews : [Review]?
    var availability : String?
    var rate : String?
}
