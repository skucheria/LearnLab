//
//  BookSessionCell.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 7/13/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class BookSessionCell : UITableViewCell{
 
    let mainInput : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .clear
        return tf
    }()
    
    let rateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cellId")
        self.addSubview(mainInput)
        self.addSubview(rateLabel)
        rateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        rateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        mainInput.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        mainInput.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mainInput.rightAnchor.constraint(equalTo: rateLabel.rightAnchor, constant: -20).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}
