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

class LoginVC: UIViewController, FUIAuthDelegate {

    let tfEmail = UITextField()
    let tfPassword = UITextField()
    let bCreate = UIButton(type: UIButton.ButtonType.system) as UIButton
    let bLogin = UIButton(type: UIButton.ButtonType.system) as UIButton
    var authUI : FUIAuth?
    var ref : DatabaseReference?
    
    override func viewDidAppear(_ animated: Bool) { //if there's already a current user session, move to main app
        if Auth.auth().currentUser != nil {
            
            let newVC = MainTabController()
            self.present(newVC, animated: true)
        }
        else{
            print("No user logged in yet")
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
        button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 43/255, alpha: 1)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action:#selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
//    @objc func handleRegister(){
//        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
//            print("form is not valid")
//            return
//        }
//        
//        if loginRegSegment.selectedSegmentIndex == 1{ //if registering
//            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//                if error == nil{
//                    print("successfully created user")
//                }
//                else{
//                    print(error)
//                }
//                //save user here
//                let values = ["name": name, "email": email ]
//                self.ref?.child("user").child(Auth.auth().currentUser?.uid ?? "autoid").updateChildValues(values)
//            }
//        }
//            
//        else{ //if logging in
//            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//                if error == nil{
//                    let newVC = MainTabController()
//                    self.present(newVC, animated: true)
//                }
//            }
//        }
//        
//    }
    
    let nameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.textColor = .black
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.textColor = .black
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.textColor = .black
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Sensei")
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
            inputsHeightConstraint?.constant = 150
            nameHeightConstraint?.isActive = false
            nameHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            nameHeightConstraint?.isActive = true
            emailHeight?.isActive = false
            emailHeight = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            emailHeight?.isActive = true
            passHeight?.isActive = false
            passHeight = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            passHeight?.isActive = true

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        self.view.isUserInteractionEnabled = true

        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers : [FUIAuthProvider] = [FUIGoogleAuth()]
        authUI?.providers = providers
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegSegment)
        setupInputsContainerView()
        setupLoginResgiterButton()
        setupProfileImageView()
        setupSegment()
        
        ref = Database.database().reference()
       
    }
    
    var inputsHeightConstraint : NSLayoutConstraint?
    var nameHeightConstraint : NSLayoutConstraint?
    var emailHeight : NSLayoutConstraint?
    var passHeight : NSLayoutConstraint?
    
    func setupInputsContainerView(){
        //x,y,width,height
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsHeightConstraint = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsHeightConstraint?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)

        //constraints for textfield
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
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
        emailHeight = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
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
        passHeight = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passHeight?.isActive = true
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
    }
    
    func setupSegment(){
        loginRegSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegSegment.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegSegment.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegSegment.heightAnchor.constraint(equalToConstant: 35).isActive=true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
