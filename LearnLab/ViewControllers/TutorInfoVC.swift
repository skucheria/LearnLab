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
    
    var time : NSNumber?
    
    var currentTutor : User? {
        didSet{
            navigationItem.title = currentTutor?.name
        }
    }
    
    //order of fields:
    // pic with name, rating, num of ratings
    // About/bio
    // Availability
    // Subjects --> tvcells with rates to click and book sessions
    // Reviews
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .cyan
        return v
    }()
    
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
    
    let dateTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 10
        tf.placeholder = "Enter date and time"
        tf.layer.borderColor = UIColor.red.cgColor
        tf.layer.borderWidth = 2
        tf.layer.masksToBounds = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.dateAndTime
        return picker
    }()


    let toolbar : UIToolbar = {
        let bar = UIToolbar()
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        bar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        return bar
    }()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupSessionButton()
        setupTF()
    }
    
    @objc func bookSession(){
        let studentID = Auth.auth().currentUser!.uid
        let tutorID = currentTutor!.id
        //first put the session in the sessions tree
        let ref = Database.database().reference().child("sessions")
        let childRef = ref.childByAutoId()
        childRef.updateChildValues(["tutorID" : tutorID!, "studentID" : studentID, "active" : "no", "startTime" : time])
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
    
    func setupTF(){
        self.view.addSubview(dateTextField)
        dateTextField.bottomAnchor.constraint(equalTo: bookSessionButton.topAnchor, constant: -20).isActive = true
        dateTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        dateTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar

    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY HH:mm  a"
        dateTextField.text = formatter.string(from: datePicker.date)
        time = (datePicker.date.timeIntervalSince1970 as AnyObject as! NSNumber)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    
    
}
