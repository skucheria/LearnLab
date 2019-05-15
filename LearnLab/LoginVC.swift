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
    }
    
    let inputsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    var loginRegisterButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        setupInputsContainerView()
        setupLoginResgiterButton()
       
        ///////////
        bCreate.frame = CGRect(x:0, y:self.view.frame.height - self.view.frame.height/3, width:self.view.frame.width, height:45)
        bCreate.backgroundColor = UIColor.lightGray
        bCreate.setTitle("Create", for: .normal)
        bCreate.tintColor = UIColor.black
        bCreate.addTarget(self, action:#selector(self.doCreate(_:)), for: .touchUpInside)

        bLogin.frame = CGRect(x:0, y:self.view.frame.height - self.view.frame.height/5, width:self.view.frame.width, height:45)
        bLogin.backgroundColor = UIColor.lightGray
        bLogin.setTitle("Login", for: .normal)
        bLogin.tintColor = UIColor.black
        bLogin.addTarget(self, action:#selector(self.doLogin(_:)), for: .touchUpInside)

        tfEmail.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 30)
        tfEmail.center = self.view.center
        tfEmail.placeholder = "Email"
        tfEmail.backgroundColor = .white
        tfEmail.textColor = .black
        tfEmail.borderStyle = .line
        tfEmail.layer.cornerRadius = 5
        tfEmail.layer.masksToBounds = true
        tfEmail.layer.borderWidth = 1
        tfEmail.keyboardType = .phonePad

        
        tfPassword.frame = CGRect(x: self.view.frame.width/4, y: self.view.frame.height - self.view.frame.height/2.25, width: self.view.frame.width/2, height: 30)
        tfPassword.placeholder = "Password"
        tfPassword.backgroundColor = .white
        tfPassword.textColor = .black
        tfPassword.borderStyle = .line
        tfPassword.layer.cornerRadius = 5
        tfPassword.layer.masksToBounds = true
        tfPassword.layer.borderWidth = 1
        tfPassword.isSecureTextEntry = true
        tfPassword.keyboardType = .emailAddress
    
        
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
    }
    
    func setupLoginResgiterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12)
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
