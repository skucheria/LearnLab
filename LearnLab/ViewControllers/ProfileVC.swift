//
//  ProfileVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/25/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase
import Stripe


class ProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate, STPAddCardViewControllerDelegate {
    
   
    var currUser : User?
    
    let topView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    let name : UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.boldSystemFont(ofSize: 24.0)
        return name
    }()
    
    let options : UITableView = {
        let options = UITableView()
        options.translatesAutoresizingMaskIntoConstraints = false
        return options
    }()
    
    let progressHUD = ProgressHUD(text: "Logging Out...")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.isUserInteractionEnabled = true
        view.addSubview(options)
        setupTopView()
        setupTableView()
//        getCurrentUserInfo()
        fetchUser()
        self.options.tableFooterView = UIView()


        options.delegate = self
        options.dataSource = self
        options.isScrollEnabled = false
        options.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        currUser = getUserForUID(Auth.auth().currentUser!.uid)
        self.view.addSubview(progressHUD)
        progressHUD.hide()
        
        var ref = Database.database().reference()
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 31/255, green: 9/255, blue: 87/355, alpha: 1)
        self.view.backgroundColor = .white
//        tabBarController?.tabBar.barTintColor = UIColor(displayP3Red: 202/255, green: 235/255, blue: 242/255, alpha: 1)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupTopView(){
        
        view.addSubview(topView)
        view.addSubview(profileImageView)
        view.addSubview(name)
        
        //constraints x,y,w,h
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
//        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true

        name.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 20).isActive = true
        name.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -62/5).isActive = true
//        name.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
//        name.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        name.widthAnchor.constraint(equalToConstant: 50)
        name.heightAnchor.constraint(equalToConstant: 20)
        
    }
    
    func getCurrentUserInfo(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let curr = User()
        ref.child("user").observeSingleEvent(of: .value
            , with: { (snapshot) in
                let tester = snapshot.value as? [String : [String:Any]] ?? [:]
                for item in tester{
//                    print("Key AKA UID: ", item.key)
//                    print("My UID: ", uid!)
                    if item.key == (uid!){
//                        print("every going in here")
                        curr.email = item.value["email"] as? String
                        curr.name = item.value["name"]as? String
                        curr.profLinik = item.value["profilePic"] as? String
                        curr.id = item.key
                        curr.bio = item.value["bio"] as? String
//                        self.name.text = curr.name
//                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
//                        self.topView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
                    }
                }
        })
        
    }
    
    func fetchUser(){
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let curr = User()
        ref.child("user").observeSingleEvent(of: .value
            , with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : [String:Any]]{
                    for item in dictionary{
//                        print(item.key)
//                        print(uid!)
                        if(item.key == (uid!)){
                            curr.email = item.value["email"] as? String
                            curr.name = item.value["name"]as? String
                            curr.profLinik = item.value["profilePic"] as? String
                            curr.id = item.key
                            curr.bio = item.value["bio"] as? String
                            curr.courses =  item.value["classes"] as? [String]
                            self.name.text = curr.name
                            let profileImageUrl = curr.profLinik
                            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
                        }
                    }
                }
        })
    }
    
    func setupTableView(){
//        view.addSubview(options)
        options.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        options.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10).isActive = true
        options.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        options.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
//        cell.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        if (indexPath.section == 0){
//            if(indexPath.row == 0){
//                cell.textLabel?.text = "View & Edit Profile"
//                return cell
//            }
//            else
//            if(indexPath.row == 0){
//                cell.textLabel?.text = "Payment Accounts"
//                return cell
//            }
            if(indexPath.row == 0){
                cell.textLabel?.text = "Become a Tutor"
                return cell
            }
            else if (indexPath.row == 1){
                cell.textLabel?.text = "Change Email"
            }
            else if(indexPath.row == 2){
                cell.textLabel?.text = "Change Password"
                return cell
            }
            else if(indexPath.row == 3){
                cell.textLabel?.text = "Logout"
                cell.textLabel?.textColor = .red
                return cell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if (indexPath.section == 0){
//            if (indexPath.row == 0){
//                let epVC = EditProfileVC()
//                self.navigationController?.pushViewController(epVC, animated: true)
//            }
//            else
//            if indexPath.row == 0{ //add a credit card
//                let addCardViewController = STPAddCardViewController()
//                addCardViewController.delegate = self
//                // Present add card view controller
//                let navigationController = UINavigationController(rootViewController: addCardViewController)
//                present(navigationController, animated: true)
//            }
            if indexPath.row == 0{ //go into registration flow
                if currUser?.tutor == "yes"{
                    let alert = UIAlertController(title: "You are already registered as a tutor!", message: nil, preferredStyle: .alert)
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
                    let reg1VC = Registration1VC()
                    let navController = UINavigationController(rootViewController: reg1VC)
                    present(navController, animated: true, completion: nil)
                }
            }
            else if indexPath.row == 1{
                
//                let reAuthUser = Auth.auth().currentUser
//                var credential: AuthCredential = EmailAuthProvider.credential(withEmail: "email", password: "password")
//
//                // Prompt the user to re-provide their sign-in credentials
//                reAuthUser?.reauthenticateAndRetrieveData(with: credential, completion: { (result, error) in
//                    if error == nil{
//                        print("reauthenticated")
//                    }
//                    else{
//                        print("Shit fucked up")
//                    }
//                })

                let alert = UIAlertController(title: "Change email", message: "Please enter your new email address.", preferredStyle: UIAlertController.Style.alert)
                alert.addTextField(configurationHandler: configurationTextField)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
                    let emailTextField = alert.textFields![0]
                    Auth.auth().currentUser?.updateEmail(to: emailTextField.text!, completion: { (error) in
                        if (error == nil){
                            print("Success")
                        }
                    })
                }))
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
            }
            else if indexPath.row == 2{
                let alert = UIAlertController(title: "Change password", message: "Please enter your new password.", preferredStyle: UIAlertController.Style.alert)
                alert.addTextField(configurationHandler: configurationTextField)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
                    let passwordTextField = alert.textFields![0]
                    passwordTextField.isSecureTextEntry = true
                    Auth.auth().currentUser?.updatePassword(to: passwordTextField.text!, completion: { (error) in
                        if (error == nil){
                            print("Success")
                        }
                    })
                }))
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
            }
            else if indexPath.row == 3{
                progressHUD.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    self.progressHUD.hide()
                    self.logout()
                }
            }
        }
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
            print("Testing logout. the current user should be nil ", Auth.auth().currentUser?.uid ?? "no user logged in")
            let newVC = LoginVC()
            self.present(newVC, animated: true)
        }
        catch{}
    }
   
    @objc func uploadPic(){
        print("Upload pic")
    }
    
    func configurationTextField(textField: UITextField!){
        textField.placeholder = "Enter new email"
    }
}
