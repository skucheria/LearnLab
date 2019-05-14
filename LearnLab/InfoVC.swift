//
//  InfoVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/12/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//


import UIKit
import FirebaseDatabase
import Firebase


class InfoVC: UIViewController {

    let first = UITextField()
    let last = UITextField()
    let gpa = UITextField()
    let bNext = UIButton(type: UIButton.ButtonType.system) as UIButton
    let tutor = UISegmentedControl()
    let tLabel = UILabel()

    var ref : DatabaseReference?
    var fstore : Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        first.frame = CGRect(x: self.view.frame.width/4, y: self.view.frame.height - self.view.frame.height/1.5, width: self.view.frame.width/2, height: 30)
        first.placeholder = "First Name"
        first.backgroundColor = .white
        first.textColor = .black
        first.borderStyle = .line
        first.layer.cornerRadius = 5
        first.layer.masksToBounds = true
        first.layer.borderWidth = 1
        
        last.frame = CGRect(x: self.view.frame.width/4, y: self.view.frame.height - self.view.frame.height/1.7, width: self.view.frame.width/2, height: 30)
        last.placeholder = "Last Name"
        last.backgroundColor = .white
        last.textColor = .black
        last.borderStyle = .line
        last.layer.cornerRadius = 5
        last.layer.masksToBounds = true
        last.layer.borderWidth = 1
        
        gpa.frame = CGRect(x: self.view.frame.width/4, y: self.view.frame.height - self.view.frame.height/1.9, width: self.view.frame.width/2, height: 30)
        gpa.placeholder = "GPA"
        gpa.backgroundColor = .white
        gpa.textColor = .black
        gpa.borderStyle = .line
        gpa.layer.cornerRadius = 5
        gpa.layer.masksToBounds = true
        gpa.layer.borderWidth = 1
        gpa.keyboardType = UIKeyboardType.decimalPad
        
        tLabel.frame = CGRect(x: self.view.frame.width/4, y: self.view.frame.height - self.view.frame.height/2.1, width: self.view.frame.width/4, height: 30)
        tLabel.text = "Tutor?"
        
        tutor.insertSegment(withTitle: "Yes", at: 0, animated: false)
        tutor.insertSegment(withTitle: "No", at: 1, animated: false)
        tutor.frame = CGRect(x: self.view.frame.width/2, y: self.view.frame.height - self.view.frame.height/2.1, width: self.view.frame.width/4, height: 30)
        
        bNext.frame = CGRect(x:0, y:self.view.frame.height - self.view.frame.height/5, width:self.view.frame.width, height:45)
        bNext.backgroundColor = UIColor.lightGray
        bNext.setTitle("Next", for: .normal)
        bNext.tintColor = UIColor.black
        bNext.addTarget(self, action:#selector(self.goNext(_:)), for: .touchUpInside)
        
        self.view.addSubview(first)
        self.view.addSubview(last)
        self.view.addSubview(gpa)
        self.view.addSubview(bNext)
        self.view.addSubview(tutor)
        self.view.addSubview(tLabel)
        ref = Database.database().reference()
        fstore = Firestore.firestore()
    }

    @objc func goNext(_ sender:Any){
        self.ref?.child("user").child((Auth.auth().currentUser?.uid)!).setValue(["firstName" : first.text, "lastName" : last.text, "gpa" : gpa.text, "isTutor" : tutor.selectedSegmentIndex])
        
        fstore.collection("users").document(Auth.auth().currentUser?.uid ?? "poop").setData(["firstName" : first.text, "lastName" : last.text, "gpa" : gpa.text, "isTutor" : tutor.selectedSegmentIndex])
        
        
        let newVC = MainTabController()
        self.present(newVC, animated: true)
    }
}
