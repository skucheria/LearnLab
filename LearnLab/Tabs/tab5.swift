
//
//  tab5.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/15/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class tab5: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([SessionsVC()], animated: false)

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
