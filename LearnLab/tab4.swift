//
//  tab4.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/12/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class tab4: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let profileView = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
//        self.setViewControllers([ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())], animated: false)
        self.setViewControllers([ProfileVC()], animated: false)

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
