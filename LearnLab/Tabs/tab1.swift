//
//  tab1.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/12/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class tab1: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let tutorsVC = TutorsVC(collectionViewLayout: UICollectionViewFlowLayout())
//        self.navigationController?.pushViewController(tutorsVC, animated: true)
//        self.present(tutorsVC, animated: false, completion: nil)
        self.setViewControllers([Tutors()], animated: false)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 255/255, green: 124/255, blue: 89/355, alpha: 1)], for:.selected)

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
