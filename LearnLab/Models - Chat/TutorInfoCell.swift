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
//        imageView.layer.borderColor = (UIColor.red).cgColor
//        imageView.layer.borderWidth = 2
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
        label.text = "Rating 5 Star"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let classLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " "
        return label
    }()
    
    let bioLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    let reviewsLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "# Reviews"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cellId")
        self.addSubview(picImageView)
        self.addSubview(nameLabel)
        self.addSubview(ratingLabel)
        self.addSubview(classLabel)
        self.addSubview(bioLabel)
        self.addSubview(reviewsLabel)
//        self.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        self.backgroundColor = .white
        self.layer.borderColor = (UIColor.lightGray).cgColor
        self.layer.borderWidth = 0.5
        
        
        //constraints
        
        picImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        picImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        picImageView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        picImageView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: picImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        ratingLabel.leftAnchor.constraint(equalTo: picImageView.rightAnchor, constant: 8).isActive = true
        ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        ratingLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        ratingLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        reviewsLabel.leftAnchor.constraint(equalTo: ratingLabel.rightAnchor, constant: 8).isActive = true
        reviewsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        reviewsLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        reviewsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        classLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        classLabel.topAnchor.constraint(equalTo: picImageView.bottomAnchor, constant: 15).isActive = true
        classLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -16).isActive = true
        classLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        classLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
