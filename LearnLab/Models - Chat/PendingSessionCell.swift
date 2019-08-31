//
//  PendingSessionCell.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 7/2/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class PendingSessionCell : UITableViewCell{
    
    var confirmIndex : Int?
    
    let confirmButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 43/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Confirm Session", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    let declineButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Decline Session", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
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
    
    var pendingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Pending confirmation"
        return label
    }()
    
    //        button.addTarget(self, action:#selector(uploadPic), for: .touchUpInside)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cellId2")
        self.addSubview(nameLabel)
        self.addSubview(classLabel)
        self.addSubview(timeLabel)
        addSubview(confirmButton)
        addSubview(declineButton)
        addSubview(pendingLabel)
        
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant:10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 13).isActive = true
//        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        classLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 10).isActive = true
//        classLabel.topAnchor.constraint(equalTo:nameLabel.bottomAnchor).isActive = true
        classLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
//        timeLabel.topAnchor.constraint(equalTo:nameLabel.bottomAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        
        pendingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pendingLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor, constant: 5).isActive = true
        
        confirmButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        confirmButton.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        declineButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        declineButton.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10).isActive = true
        declineButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
        declineButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        confirmButton.addTarget(self, action:#selector(didTapConfirm), for: .touchUpInside)
        declineButton.addTarget(self, action:#selector(didTapDecline), for: .touchUpInside)
    }
    
    
    
    weak var delegate: CustomCellDelegate?
    
    @objc func didTapConfirm() {
        delegate?.confirmPressed(cell: self)
    }
    
    @objc func didTapDecline(){
        delegate?.declinePressed(cell: self)
    }
    
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol CustomCellDelegate: class {
    func confirmPressed(cell: PendingSessionCell)
    
    func declinePressed(cell: PendingSessionCell)
}
