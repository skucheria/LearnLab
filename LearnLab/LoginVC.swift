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
    
    @objc func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil{
                print("successfully created user")
            }
            else{
                print(error)
            }
            //save user here
            let values = ["name": name, "email": email ]
            self.ref?.child("user").child(Auth.auth().currentUser?.uid ?? "autoid").updateChildValues(values)
        }
    }
    
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
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Sensei")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers : [FUIAuthProvider] = [FUIGoogleAuth()]
        authUI?.providers = providers
        
        // Do any additional setup after loading the view.
      
        ////constraints for auto-layout
        ////////////
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        setupInputsContainerView()
        setupLoginResgiterButton()
        setupProfileImageView()
        
        
       
        ///////////
//        bCreate.frame = CGRect(x:0, y:self.view.frame.height - self.view.frame.height/3, width:self.view.frame.width, height:45)
//        bCreate.backgroundColor = UIColor.lightGray
//        bCreate.setTitle("Create", for: .normal)
//        bCreate.tintColor = UIColor.black
//        bCreate.addTarget(self, action:#selector(self.doCreate(_:)), for: .touchUpInside)
//
//        bLogin.frame = CGRect(x:0, y:self.view.frame.height - self.view.frame.height/5, width:self.view.frame.width, height:45)
//        bLogin.backgroundColor = UIColor.lightGray
//        bLogin.setTitle("Login", for: .normal)
//        bLogin.tintColor = UIColor.black
//        bLogin.addTarget(self, action:#selector(self.doLogin(_:)), for: .touchUpInside)
//
//        tfEmail.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 30)
//        tfEmail.center = self.view.center
//        tfEmail.placeholder = "Email"
//        tfEmail.backgroundColor = .white
//        tfEmail.textColor = .black
//        tfEmail.borderStyle = .line
//        tfEmail.layer.cornerRadius = 5
//        tfEmail.layer.masksToBounds = true
//        tfEmail.layer.borderWidth = 1
//        tfEmail.keyboardType = .phonePad
//
//
//        tfPassword.frame = CGRect(x: self.view.frame.width/4, y: self.view.frame.height - self.view.frame.height/2.25, width: self.view.frame.width/2, height: 30)
//        tfPassword.placeholder = "Password"
//        tfPassword.backgroundColor = .white
//        tfPassword.textColor = .black
//        tfPassword.borderStyle = .line
//        tfPassword.layer.cornerRadius = 5
//        tfPassword.layer.masksToBounds = true
//        tfPassword.layer.borderWidth = 1
//        tfPassword.isSecureTextEntry = true
//        tfPassword.keyboardType = .emailAddress
    
        
//        self.view.addSubview(bCreate)
//        self.view.addSubview(bLogin)
//        self.view.addSubview(tfEmail)
//        self.view.addSubview(tfPassword)
        
        ref = Database.database().reference()
    }
    
    
    func setupInputsContainerView(){
        //x,y,width,height
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)

        //constraints for textfield
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        //name separator constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //email textfield constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        //email separator constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //password textfield constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.topAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        
        
    }
    
    func setupLoginResgiterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    

    @objc func doCreate(_ sender: Any) {
        //first create the user
        if let email = tfEmail.text, let password = tfPassword.text{
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                print(Auth.auth().currentUser?.uid)
                //after creating the user in the database, move to view where user enters info
                let newVC = InfoVC()
                self.present(newVC, animated: true)
            }
        }
    }
    
    @objc func doLogin(_ sender: Any) {
        if Auth.auth().currentUser == nil{ //not logged in
            // if let authVC = authUI?.authViewController() {
            //   present(authVC, animated: true, completion: nil)
            //                let newViewController = SecondVC()
            //                self.navigationController?.pushViewController(newViewController, animated: true)
            //  }
            if let email = tfEmail.text, let password = tfPassword.text{
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error == nil{
                        self.bLogin.setTitle("Logout", for: .normal)
                        let newVC = MainTabController()
                        self.present(newVC, animated: true)
                    }
                }
            }
        }
        else{ //logged in. sign out
            do{
                try Auth.auth().signOut()
                self.bLogin.setTitle("Login", for: .normal)
            }
            catch{}

        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error == nil {
            let newVC = MainTabController()
            self.present(newVC, animated: true)
        }
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
