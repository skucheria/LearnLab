//
//  TutorInfoVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/8/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class TutorInfoVC: UIViewController {

    var currentTutor : User? {
        didSet{
            navigationItem.title = currentTutor?.name
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    

    
    
}
