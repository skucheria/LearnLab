//
//  userCellClass.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/23/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit


class userCellClass : UITableViewCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel!.frame = CGRect(x: 60, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel!.frame = CGRect(x: 60, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
    }
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "person")
        imageView.layer.cornerRadius = 24
        imageView.layer.borderColor = (UIColor.red).cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cellId")
        addSubview(profileImageView)
        //constraints x,y,w,h
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
