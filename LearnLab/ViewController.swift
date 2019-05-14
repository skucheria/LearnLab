//
//  ViewController.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/10/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseUI
import Firebase

class ViewController: UIViewController, FUIAuthDelegate {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var bCreate: UIButton!
    @IBOutlet weak var bLogin: UIButton!
    
    var authUI : FUIAuth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers : [FUIAuthProvider] = [FUIGoogleAuth()]
        authUI?.providers = providers
        
//        if Auth.auth().currentUser != nil {
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainTab") as! MainTabController
//            self.present(newViewController, animated: true, completion: nil)
//        }
        // Do any additional setup after loading the view.
////
//        self.bLogin.frame = CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: self.view.frame.width, height: 30)
//        self.bLogin.center = self.view.center
//
//        self.bCreate.frame = CGRect(x: self.view.frame.width/2, y: self.view.frame.height - self.view.frame.height/3, width: self.view.frame.width, height: 30)
//        self.bCreate.center = self.view.center
//
//        self.view.addSubview(self.bLogin)
//        self.view.addSubview(self.bCreate)
        
        
        

    }
    
    @IBAction func doCreate(_ sender: Any) {
        if let email = tfEmail.text, let password = tfPassword.text{
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                print(Auth.auth().currentUser?.uid)
            }
        }
    }
    
    @IBAction func doLogin(_ sender: Any) {
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
//                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainTab") as! MainTabController
//                        self.present(newViewController, animated: true, completion: nil)
                        
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
            bLogin.setTitle("Logout", for: .normal)
            print("GETTING IN HERE")
            
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainTab") as! MainTabController
//            self.present(newViewController, animated: true, completion: nil)

            
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
