//
//  LoginVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/12/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseDatabase

class LoginVC: UIViewController, UITextFieldDelegate, FUIAuthDelegate {

    let tfEmail = UITextField()
    let tfPassword = UITextField()
    let bCreate = UIButton(type: UIButton.ButtonType.system) as UIButton
    let bLogin = UIButton(type: UIButton.ButtonType.system) as UIButton
    var ref : DatabaseReference?
    let progressHUD = ProgressHUD(text: "Logging in...")

    override func viewDidAppear(_ animated: Bool) { //if there's already a current user session, move to main app
        if Auth.auth().currentUser != nil {
            let newVC = MainVC()
            newVC.modalPresentationStyle = .fullScreen
            self.present(newVC, animated: false)
        }
        else{
            print("No user logged in")
        }
    }
    
    let inputsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true

        return view
    }()
    
    let loginRegisterButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 212/255, alpha: 1)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action:#selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var nameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.textColor = .black
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = .next
        tf.delegate = self
        return tf
    }()
    
    let nameSeparatorView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.textColor = .black
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = .next
        tf.delegate = self
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    let emailSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.textColor = .black
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.returnKeyType = .done
        tf.delegate = self
        return tf
    }()
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "Sensei")
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 5
        let gest = UITapGestureRecognizer(target: self, action: #selector(uploadPic))
        gest.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gest)
        return imageView
    }()
    
    let loginRegSegment : UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Login", "Register"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.tintColor = .white
        segment.selectedSegmentIndex = 1
        segment.addTarget(self, action: #selector(segChanged), for: .valueChanged )
        segment.isUserInteractionEnabled = true
        return segment
    }()
    
    let picSeparaterView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profImageButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 212/255, alpha: 1)
        button.setTitle("Select profile image", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action:#selector(uploadPic), for: .touchUpInside)
        return button
    }()
    
    @objc func segChanged(){
        let title = loginRegSegment.titleForSegment(at: loginRegSegment.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        //change height of input container view
        if title == "Login"{
            inputsHeightConstraint?.constant = 100
            nameHeightConstraint?.isActive = false
            nameHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
            nameHeightConstraint?.isActive = true
            emailHeight?.isActive = false
            emailHeight = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
            emailHeight?.isActive = true
            passHeight?.isActive = false
            passHeight = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
            passHeight?.isActive = true
        }
        else{
            inputsHeightConstraint?.constant = 200
            nameHeightConstraint?.isActive = false
            nameHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
            nameHeightConstraint?.isActive = true
            emailHeight?.isActive = false
            emailHeight = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
            emailHeight?.isActive = true
            passHeight?.isActive = false
            passHeight = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
            passHeight?.isActive = true

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 31/255, green: 9/255, blue: 87/255, alpha: 1)
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegSegment)
        view.addSubview(name)
        setupInputsContainerView()
        setupLoginResgiterButton()
        setupProfileImageView()
        setupSegment()
        
        ref = Database.database().reference()
    }
    
    let name : UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.boldSystemFont(ofSize: 36.0)
        name.textColor = UIColor.white
        name.text  = "LearnLab"
        return name
    }()
    
    var inputsHeightConstraint : NSLayoutConstraint?
    var nameHeightConstraint : NSLayoutConstraint?
    var emailHeight : NSLayoutConstraint?
    var passHeight : NSLayoutConstraint?
    var imageButton : NSLayoutConstraint?
    
    func setupInputsContainerView(){
        //x,y,width,height
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsHeightConstraint = inputsContainerView.heightAnchor.constraint(equalToConstant: 200)
        inputsHeightConstraint?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(picSeparaterView)
        inputsContainerView.addSubview(profImageButton)

        //constraints for textfield
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        nameHeightConstraint?.isActive = true
        
        //name separator constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //email textfield constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailHeight = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        emailHeight?.isActive = true
        
        //email separator constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //password textfield constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.topAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passHeight = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        passHeight?.isActive = true
        
        picSeparaterView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        picSeparaterView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        picSeparaterView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        picSeparaterView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //select image button constraints
        profImageButton.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        profImageButton.topAnchor.constraint(equalTo: picSeparaterView.topAnchor).isActive = true
        profImageButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        imageButton = profImageButton.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        imageButton?.isActive = true
    }
    
    func setupLoginResgiterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegSegment.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        name.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
    }
    
    func setupSegment(){
        loginRegSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegSegment.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegSegment.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegSegment.heightAnchor.constraint(equalToConstant: 35).isActive=true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField{
            emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else{
            self.view.endEditing(true)
        }
        return true
    }

}
