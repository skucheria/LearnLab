//
//  NewReviewVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 7/28/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class NewReviewVC: UIViewController {
    
    let detail : UILabel = {
        let label = UILabel()
        label.text = "Write a review for "
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "New Review"
    
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
