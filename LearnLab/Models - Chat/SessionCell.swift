//
//  SessionCell.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 8/27/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class SessionCell : UITableViewCell{
    
    var nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var classLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var timeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cellId")
        self.addSubview(nameLabel)
        self.addSubview(classLabel)
        self.addSubview(timeLabel)
        
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant:10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        classLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 10).isActive = true
        classLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
