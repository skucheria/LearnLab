//
//  BookSessionVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 7/2/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class BookSessionVC: UIViewController {
    var time : NSNumber?
    var dur : NSNumber?
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
        button.backgroundColor = UIColor(displayP3Red: 255/255, green: 124/255, blue: 89/355, alpha: 1)
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
    
    let durationPicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.countDownTimer
        picker.minuteInterval = 15
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
    
    let toolbar2 : UIToolbar = {
        let bar = UIToolbar()
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDurPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDurPicker));
        bar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        return bar
    }()
    
    let optionsTV : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let topSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeInput : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .clear
        tf.placeholder = "Pick date and time of session"
        return tf
    }()
    
    let timeSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let durationInput : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .clear
        tf.placeholder = "How long do you want the session?"
        return tf
    }()
    
    let durationSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let locationInput : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .clear
        tf.placeholder = "Where will the session be?"
        return tf
    }()
    
    let locationSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Book Session"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 255/255, green: 124/255, blue: 89/355, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        
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
        self.view.addSubview(topSeparator)
        topSeparator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topSeparator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topSeparator.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 10).isActive = true
        topSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.view.addSubview(timeInput)
        timeInput.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        timeInput.topAnchor.constraint(equalTo: topSeparator.bottomAnchor).isActive = true
        timeInput.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        timeInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        timeInput.inputView = datePicker
        timeInput.inputAccessoryView = toolbar
        self.view.addSubview(timeSeparator)
        timeSeparator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        timeSeparator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        timeSeparator.topAnchor.constraint(equalTo: timeInput.bottomAnchor).isActive = true
        timeSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.view.addSubview(durationInput)
        durationInput.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        durationInput.topAnchor.constraint(equalTo: timeSeparator.bottomAnchor).isActive = true
        durationInput.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        durationInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        durationInput.inputView = durationPicker
        durationInput.inputAccessoryView = toolbar2
        self.view.addSubview(durationSeparator)
        durationSeparator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        durationSeparator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        durationSeparator.topAnchor.constraint(equalTo: durationInput.bottomAnchor).isActive = true
        durationSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.view.addSubview(locationInput)
        locationInput.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        locationInput.topAnchor.constraint(equalTo: durationSeparator.bottomAnchor).isActive = true
        locationInput.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        locationInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.view.addSubview(locationSeparator)
        locationSeparator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        locationSeparator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        locationSeparator.topAnchor.constraint(equalTo: locationInput.bottomAnchor).isActive = true
        locationSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.view.addSubview(bookSessionButton)
        bookSessionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bookSessionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bookSessionButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bookSessionButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    
    @objc func bookSession(){
        print("booked session")
        if (timeInput.text!.isEmpty || durationInput.text!.isEmpty || locationInput.text!.isEmpty) {
            let alert = UIAlertController(title: "You must fill out all session fields!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let studentID = Auth.auth().currentUser!.uid
            let tutorID = currentTutor!.id
            //first put the session in the sessions tree
            let ref = Database.database().reference().child("sessions")
            let childRef = ref.childByAutoId()
            childRef.updateChildValues(["tutorID" : tutorID!, "studentID" : studentID, "active" : "no", "startTime" : time, "endTime" : dur, "declined" : "no", "sessionID" : childRef.key])
            //wanna also create a tree for sessions by user --> do it for both tutor and students
            let ref2 = Database.database().reference().child("grouped-sessions").child(studentID)
            ref2.updateChildValues([childRef.key! : 1])
            let ref3 = Database.database().reference().child("grouped-sessions").child(tutorID!)
            ref3.updateChildValues([childRef.key! : 1])
    
            let sender = PushNotificationSender()
            sender.sendPushNotification(to: currentTutor!.fcmToken!, title: "Session request", body: "New tutor session request")
        }
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
        formatter.dateFormat = "EEEE, MMM d, h:mm a"
        timeInput.text = formatter.string(from: datePicker.date)
        time = (datePicker.date.timeIntervalSince1970 as AnyObject as! NSNumber)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func doneDurPicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "h m"
        let helper = formatter.string(from: durationPicker.date)
        let timeArr = helper.components(separatedBy: " ")
        durationInput.text = timeArr[0] + " hour(s) " + timeArr[1] + " minute(s)"
        dur = durationPicker.countDownDuration as NSNumber
        self.view.endEditing(true)
    }
    
    @objc func cancelDurPicker(){
        self.view.endEditing(true)
    }
}
