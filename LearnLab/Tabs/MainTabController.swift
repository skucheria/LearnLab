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
        firstVC.tabBarItem = UITabBarItem(title: "Tutors", image: UIImage(named: "tutor_normal"), selectedImage: UIImage(named: "tutor_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        firstVC.tabBarItem.tag = 0
        
        let secondVC = tab2()
        secondVC.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(named: "messages_normal"), selectedImage: UIImage(named: "messages_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        secondVC.tabBarItem.tag = 1
        
        let thirdVC = tab3()
        thirdVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search_normal"), selectedImage: UIImage(named: "search_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        thirdVC.tabBarItem.tag = 2
        
        let fifthVC = tab5()
        fifthVC.tabBarItem = UITabBarItem(title: "Sessions", image: UIImage(named: "sessions_normal"), selectedImage: UIImage(named: "sessions_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        fifthVC.tabBarItem.tag = 3
        
        let fourthVC = tab4()
        fourthVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "avatar_normal"), selectedImage: UIImage(named: "avatar")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        fourthVC.tabBarItem.tag = 4
        
        
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
