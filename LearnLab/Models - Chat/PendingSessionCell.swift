//
//  PendingSessionCell.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 7/2/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class PendingSessionCell : UITableViewCell{
    
    let infoLabel : UILabel = {
        let label = UILabel()
        label.text = "Session info"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let confirmButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 43/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Confirm Session", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let declineButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Decline Session", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    //        button.addTarget(self, action:#selector(uploadPic), for: .touchUpInside)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cellId")
        addSubview(infoLabel)
        addSubview(confirmButton)
        addSubview(declineButton)
        
        infoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        infoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        confirmButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        confirmButton.topAnchor.constraint(equalTo: self.infoLabel.bottomAnchor, constant: 10).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        declineButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        declineButton.topAnchor.constraint(equalTo: self.infoLabel.bottomAnchor, constant: 10).isActive = true
        declineButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
        declineButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        confirmButton.addTarget(self, action:#selector(didTapConfirm), for: .touchUpInside)
        
        declineButton.addTarget(self, action:#selector(didTapDecline), for: .touchUpInside)


    }
    
    var delegate: CustomCellDelegate?
    
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
