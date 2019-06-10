//
//  TutorInfoCell.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/8/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class TutorInfoCell: UITableViewCell {

    let picImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "person")
        imageView.layer.cornerRadius = 36
        imageView.layer.borderColor = (UIColor.red).cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    let classLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    let bioLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cellId")
        self.addSubview(picImageView)
        self.addSubview(nameLabel)
        self.addSubview(ratingLabel)
        self.addSubview(classLabel)
        self.addSubview(bioLabel)
        //constraints
        
        picImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        picImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        picImageView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        picImageView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: picImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}