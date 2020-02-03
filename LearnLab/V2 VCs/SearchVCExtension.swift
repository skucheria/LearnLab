//
//  SearchVCExtension.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 2/3/20.
//  Copyright © 2020 Siddharth Kucheria. All rights reserved.
//

import UIKit

extension NewSearchVC{
    
    func addSubviews(){
        self.view.addSubview(searchBar)
        self.view.addSubview(getStartedLabel)
        self.view.addSubview(searchTV)
        searchTV.delegate = self
        searchTV.dataSource = self
        searchTV.register(ClassInfoCell.self, forCellReuseIdentifier: "cellId")
        searchTV.isHidden = true
    }
    
    func layoutViews(){
        searchBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive =  true
        
        getStartedLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        getStartedLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        getStartedLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        searchTV.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        searchTV.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        searchTV.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        searchTV.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    @objc func goBack(){
        dismiss(animated: false, completion: nil)
    }
}
