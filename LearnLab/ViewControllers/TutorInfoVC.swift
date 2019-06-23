//
//  TutorInfoVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/8/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class TutorInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
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
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Sensei")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 125/2
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
    let bioLabel : UILabel = {
        let label = UILabel()
        label.text = "About"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let aboutText : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let availLabel : UILabel = {
        let label = UILabel()
        label.text = "Availaility"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let availText : UILabel = {
        let label = UILabel()
        label.text = "MWF Afternoons"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subjectsLabel : UILabel = {
        let label = UILabel()
        label.text = "Subjects"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subjectsTV : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white

        setupInfoView()
        subjectsTV.delegate = self
        subjectsTV.dataSource = self
        subjectsTV.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
//        setupSessionButton()
//        setupTF()
    }
    
    func setupInfoView(){
        self.view.addSubview(profileImageView)
        let barHeight = 2 *  (self.navigationController?.navigationBar.frame.height)!
        profileImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: currentTutor!.profLinik!)
        self.view.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 10).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameLabel.text = currentTutor!.name
        self.view.addSubview(bioLabel)
        bioLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        bioLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        bioLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.view.addSubview(aboutText)
        aboutText.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        aboutText.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 5).isActive = true
        aboutText.widthAnchor.constraint(equalToConstant: 150).isActive = true
        aboutText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        aboutText.text = currentTutor!.bio
        self.view.addSubview(availLabel)
        availLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        availLabel.topAnchor.constraint(equalTo: aboutText.bottomAnchor, constant: 10).isActive = true
        availLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        availLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.view.addSubview(availText)
        availText.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        availText.topAnchor.constraint(equalTo: availLabel.bottomAnchor, constant: 5).isActive = true
        availText.widthAnchor.constraint(equalToConstant: 150).isActive = true
        availText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.view.addSubview(subjectsLabel)
        subjectsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        subjectsLabel.topAnchor.constraint(equalTo: availText.bottomAnchor, constant: 10).isActive = true
        subjectsLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        subjectsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.view.addSubview(subjectsTV)
        subjectsTV.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        subjectsTV.topAnchor.constraint(equalTo: subjectsLabel.bottomAnchor, constant: 5).isActive = true
        subjectsTV.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        subjectsTV.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = "Cell"
        return cell
    }
    
    
    
    
    
    
    
    //for booking session view
    
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
