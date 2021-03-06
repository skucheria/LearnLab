//
//  EditProfileVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/29/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class EditProfileVC: UIViewController, UITextFieldDelegate {

//    var ref = Database.database().reference()
    
    let accountDetails : UILabel = {
        let label = UILabel()
        label.text = "Account Details"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let name : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        return tf
    }()
    
    let email : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let bioLabel : UILabel = {
        let label = UILabel()
        label.text = "Biography"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bioText : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Sell yourself! Include any experience tutoring or TA'ing, qualifications, awards or something interesting about yourself."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.delegate = self
        return tf
    }()
    
    lazy var editButton : UIBarButtonItem = {
        let edit = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editPressed))
        edit.title = "Save"
        return edit
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

        let gest = UITapGestureRecognizer(target: self, action: #selector(uploadPic))
        gest.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gest)
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = editButton
//        self.view.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 204/255, alpha: 1)
        self.title = "Edit Profile"
        setupPicView()
        setupBioFields()
        setupTfs()
    }
    
    func setupPicView(){
        self.view.addSubview(profileImageView)
        let barHeight = 2 *  (self.navigationController?.navigationBar.frame.height)!
        profileImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
    }
    
    func setupBioFields(){
        self.view.addSubview(bioLabel)
        bioLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 13).isActive = true
        bioLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        bioLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(bioText)
        bioText.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bioText.topAnchor.constraint(equalTo: bioLabel.bottomAnchor).isActive = true
        bioText.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bioText.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupTfs(){
        self.view.addSubview(accountDetails)
        accountDetails.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        accountDetails.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        accountDetails.widthAnchor.constraint(equalToConstant: 200).isActive = true
        accountDetails.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(name)
        name.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        name.topAnchor.constraint(equalTo: accountDetails.bottomAnchor, constant: 4).isActive = true
        name.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        name.heightAnchor.constraint(equalToConstant: 35).isActive = true

        self.view.addSubview(email)
        email.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        email.topAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        email.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        email.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        getCurrentUserInfo()
        
        
    }
    
    func getCurrentUserInfo(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let curr = User()
        ref.child("user").observeSingleEvent(of: .value
            , with: { (snapshot) in
                let tester = snapshot.value as? [String : [String:Any] ] ?? [:]
                for item in tester{
                    //                    print("Key AKA UID: ", item.key)
                    //                    print("My UID: ", uid!)
                    if item.key == (uid!){
                        //                        print("every going in here")
                        curr.email = item.value["email"] as? String
                        curr.name = item.value["name"] as? String
                        curr.profLinik = item.value["profilePic"] as? String 
                        curr.id = item.key
                        self.name.text = curr.name
                        self.email.text = curr.email
                        let profileImageUrl = curr.profLinik
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
                    }
                }
        })
    }
    
    @objc func editPressed(){
    
        let nameText = name.text
        let emailText = email.text
        let vals = ["name" : nameText, "email": emailText]
        var ref = Database.database().reference()
        ref.child("user").child(Auth.auth().currentUser?.uid ?? "autoid").updateChildValues(vals) //updating with url link for image
    }
    
    
    @objc func uploadPic(){
        print("Upload pic")
    }

}
