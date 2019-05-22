//
//  ChatLogVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/22/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class ChatLogVC : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chat Log"
        
        setupInputComponents()
    }
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = .red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(containerView)
        
        //constraints x,y,w,h
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalToConstant: (view.frame.height - (self.tabBarController?.tabBar.frame.height)!)).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        
    }
    
    
    
    
    
    
}
