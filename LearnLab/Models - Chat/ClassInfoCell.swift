//
//  ClassInfoCell.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/9/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class ClassInfoCell: UITableViewCell {
    
    let codeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cellId")
        self.addSubview(codeLabel)
        self.addSubview(titleLabel)
        
        codeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        codeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        codeLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 3).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
