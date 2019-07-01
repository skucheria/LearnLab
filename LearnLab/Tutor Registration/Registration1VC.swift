//
//  Registration1VC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/8/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class Registration1VC: UIViewController, UITextFieldDelegate {
    
    let bioLabel : UILabel = {
        let label = UILabel()
        label.text = "Create your short bio (between 70 and 125 characters) "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let gpaLabel : UILabel = {
        let label = UILabel()
        label.text = "Enter your GPA: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    lazy var bioTV : UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = .clear
        tv.isScrollEnabled = false

        return tv
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
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.textColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        return button
    }()
    
    var ref : DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        // Do any additional setup after loading the view.
        self.view.addSubview(bioLabel)
        self.view.addSubview(bioTV)
        self.view.addSubview(nextButton)
        self.view.addSubview(cancelButton)
        
        ref = Database.database().reference()
        
        setupBio()
        setupButton()
    }
    
    func setupBio(){
        //setup constraints for bio labe and textfield
        bioLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        bioLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bioLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        
        bioTV.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bioTV.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 5).isActive = true
        bioTV.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        bioTV.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    func setupButton(){
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        cancelButton.isEnabled = false
    }
    
    @objc func nextPressed(){
        let reg2 = Registration2VC()
        self.present(reg2, animated: false)
//        ref?.child("user").child((Auth.auth().currentUser!.uid)).updateChildValues(["bio" : bioTV.text!, "tutor" : "yes"])
    }
    
    @objc func cancelPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func checkField(_ sender: UITextView) {
        if bioTV.text!.isEmpty{
            cancelButton.isEnabled = false
        }
        else{
            cancelButton.isEnabled = true
        }
    }

}
