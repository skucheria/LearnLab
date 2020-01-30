//
//  MainVCExtension.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 1/30/20.
//  Copyright © 2020 Siddharth Kucheria. All rights reserved.
//

import UIKit

extension NewMainVC {
    func addSubviews(){
        self.view.addSubview(mainLabel)
        self.view.addSubview(profileImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(menuButton)
        self.view.addSubview(messagesButton)
        self.view.addSubview(sessionsLabel)
        self.view.addSubview(sessionSegment)
        self.view.addSubview(sessionsTV)
        self.view.addSubview(bookButton)
        
        sessionsTV.delegate = self
        sessionsTV.dataSource = self
        sessionsTV.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")

    }
    
    func setupSubviews(){
        mainLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        menuButton.topAnchor.constraint(equalTo: mainLabel.topAnchor).isActive = true
        menuButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 35).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        messagesButton.topAnchor.constraint(equalTo: mainLabel.topAnchor).isActive = true
        messagesButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        
        sessionsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        sessionsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        
        sessionSegment.topAnchor.constraint(equalTo: sessionsLabel.bottomAnchor, constant: 5).isActive = true
        sessionSegment.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sessionSegment.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        sessionSegment.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        
        bookButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        bookButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        bookButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        bookButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        sessionsTV.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        sessionsTV.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        sessionsTV.topAnchor.constraint(equalTo: sessionSegment.bottomAnchor, constant: 8).isActive = true
        sessionsTV.bottomAnchor.constraint(equalTo: bookButton.topAnchor, constant: -9).isActive = true
    }
    
    
    
}
