//
//  TutorInfoVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/8/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class TutorInfoVC: UIViewController {

    let bookSessionButton  : UIButton = {
        let button = UIButton()
        button.setTitle("Book Session", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 43/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(bookSession), for: .touchUpInside)
        return button
        
    }()
    
    var currentTutor : User? {
        didSet{
            navigationItem.title = currentTutor?.name
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupSessionButton()
        
    }
    
    @objc func bookSession(){
        let studentID = Auth.auth().currentUser!.uid
        let tutorID = currentTutor!.id
        
        //first put the session in the sessions tree
        let ref = Database.database().reference().child("sessions")
        let childRef = ref.childByAutoId()
        childRef.updateChildValues(["tutorID" : tutorID!, "studentID" : studentID, "active" : "no"])
        
        //wanna also create a tree for sessions by user --> do it for both tutor and students
        let ref2 = Database.database().reference().child("grouped-sessions").child(studentID)
        ref2.updateChildValues([childRef.key! : 1])
        
        let ref3 = Database.database().reference().child("grouped-sessions").child(tutorID!)
        ref3.updateChildValues([childRef.key! : 1])
        
        
    }
    
    func setupSessionButton(){
        self.view.addSubview(bookSessionButton)
        bookSessionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bookSessionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 12).isActive = true
        bookSessionButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        bookSessionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    

    
    
}
