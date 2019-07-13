//
//  BookSessionVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 7/2/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class BookSessionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var time : NSNumber?
    
    var currentTutor : User? {
        didSet{
            infoLabel.text = "Book session with " + currentTutor!.name!
        }
    }
    
    let infoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        return label
    }()
    
    let detailsLabel : UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    let optionsTV : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Book Session"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 255/255, green: 124/255, blue: 89/355, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        
        optionsTV.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        optionsTV.delegate = self
        optionsTV.dataSource = self
        optionsTV.isScrollEnabled = false
        setupComponents()
//        setupSessionButton()
//        setupTF()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupComponents(){
        self.view.addSubview(infoLabel)
        infoLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        infoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.view.addSubview(detailsLabel)
        detailsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        detailsLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20).isActive = true
        detailsLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.view.addSubview(optionsTV)
        optionsTV.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        optionsTV.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 5).isActive = true
        optionsTV.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        optionsTV.heightAnchor.constraint(equalToConstant: 220).isActive = true
    }
    
    
    @objc func bookSession(){
        print("booked session")
        let studentID = Auth.auth().currentUser!.uid
        let tutorID = currentTutor!.id
        //first put the session in the sessions tree
        let ref = Database.database().reference().child("sessions")
        let childRef = ref.childByAutoId()
        childRef.updateChildValues(["tutorID" : tutorID!, "studentID" : studentID, "active" : "no", "startTime" : time, "declined" : "no", "sessionID" : childRef.key])
        //wanna also create a tree for sessions by user --> do it for both tutor and students
        let ref2 = Database.database().reference().child("grouped-sessions").child(studentID)
        ref2.updateChildValues([childRef.key! : 1])
        let ref3 = Database.database().reference().child("grouped-sessions").child(tutorID!)
        ref3.updateChildValues([childRef.key! : 1])
        
        let sender = PushNotificationSender()
        sender.sendPushNotification(to: currentTutor!.fcmToken!, title: "Session request", body: "New tutor session request")
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
        formatter.dateFormat = "EEEE, MMM d h:mm  a"
        dateTextField.text = formatter.string(from: datePicker.date)
        time = (datePicker.date.timeIntervalSince1970 as AnyObject as! NSNumber)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        if indexPath.row == 0{
            cell.textLabel?.text = "Course info stuff will go here with rate"
        }
        else if indexPath.row == 1{
            cell.textLabel?.text = "Selec time..."
        }
        else if indexPath.row == 2{
            cell.textLabel?.text = "Enter duration of session"
        }
        else if indexPath.row == 3{
            cell.textLabel?.text = "Enter lcoation? --> need to figure out"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
