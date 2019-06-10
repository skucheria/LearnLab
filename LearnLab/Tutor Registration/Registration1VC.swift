//
//  Registration1VC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/8/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class Registration1VC: UIViewController {
    
    let bioLabel : UILabel = {
        let label = UILabel()
        label.text = "Enter your bio: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gpaLabel : UILabel = {
        let label = UILabel()
        label.text = "Enter your GPA: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bioTF : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        return tf
    }()
    
    let gpaTF : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.keyboardType = UIKeyboardType.decimalPad
        return tf
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.titleLabel?.textColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        return button
    }()
    
    var ref : DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        // Do any additional setup after loading the view.
        self.view.addSubview(bioLabel)
        self.view.addSubview(gpaLabel)
        self.view.addSubview(bioTF)
        self.view.addSubview(gpaTF)
        self.view.addSubview(nextButton)
        
        ref = Database.database().reference()
        
        setupBio()
        setupGpa()
        setupButton()
        
        
    }
    
    func setupBio(){
        //setup constraints for bio labe and textfield
        bioLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        bioLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bioLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        
        bioTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        bioTF.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 10).isActive = true
        bioTF.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bioTF.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setupGpa(){
        gpaLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        gpaLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        gpaLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        gpaLabel.topAnchor.constraint(equalTo: bioTF.bottomAnchor, constant: 15).isActive = true
        
        gpaTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        gpaTF.topAnchor.constraint(equalTo: gpaLabel.bottomAnchor, constant: 10).isActive = true
//        gpaTF.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        gpaTF.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setupButton(){
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func nextPressed(){
        let reg2 = Registration2VC()
        self.present(reg2, animated: false)
//        ref?.child("user").child((Auth.auth().currentUser!.uid)).updateChildValues(["bio" : bioTF.text!, "gpa" : gpaTF.text!, "tutor" : "yes"])
    }

}
