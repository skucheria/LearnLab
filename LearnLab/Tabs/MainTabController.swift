//
//  MainTabController.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/12/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVC = tab1()
        firstVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        let secondVC = tab2()
        secondVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
        
        let thirdVC = tab3()
        thirdVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        
        let fifthVC = tab5()
        fifthVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 3)
        
        let fourthVC = tab4()
        fourthVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 4)

        
        
        let tabBarList = [firstVC, secondVC, thirdVC, fifthVC, fourthVC]
        
        viewControllers = tabBarList
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
