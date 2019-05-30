//
//  ProfileVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/25/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase


class ProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var currUser : User?
    
    let topView : UIView = {
        let view = UIView()
        view.backgroundColor = .green
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
        imageView.layer.cornerRadius = 75/2

        imageView.layer.borderColor = UIColor.black.cgColor
        
        let gest = UITapGestureRecognizer(target: self, action: #selector(uploadPic))
        gest.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gest)
        return imageView
    }()
    
    let name : UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let options : UITableView = {
        let options = UITableView()
        options.translatesAutoresizingMaskIntoConstraints = false
        return options
    }()
    
//    let alert : UIAlertController = {
//        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: nil))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//        return alert
//    }()
    
    let progressHUD = ProgressHUD(text: "Logging Out...")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ProfileVC"
        self.view.backgroundColor = .white
        self.view.isUserInteractionEnabled = true
        view.addSubview(options)

        setupTopView()
        setupTableView()
        getCurrentUserInfo()
        
        options.delegate = self
        options.dataSource = self
        options.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        self.view.addSubview(progressHUD)
        progressHUD.hide()

    }
    
    func setupTopView(){
        
        view.addSubview(topView)
        view.addSubview(profileImageView)
        view.addSubview(name)
        
        //constraints x,y,w,h
        let barHeight = 2 *  (self.navigationController?.navigationBar.frame.height)!
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: barHeight).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true

        
        name.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        name.widthAnchor.constraint(equalToConstant: 50)
        name.heightAnchor.constraint(equalToConstant: 20)
        
    }
    
    func getCurrentUserInfo(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let curr = User()
        ref.child("user").observeSingleEvent(of: .value
            , with: { (snapshot) in
                let tester = snapshot.value as? [String : [String:String] ] ?? [:]
                for item in tester{
//                    print("Key AKA UID: ", item.key)
//                    print("My UID: ", uid!)
                    if item.key == (uid!){
//                        print("every going in here")
                        curr.email = item.value["email"]
                        curr.name = item.value["name"]
                        curr.profLinik = item.value["profilePic"]
                        curr.id = item.key
                        self.name.text = curr.name
                        let profileImageUrl = curr.profLinik
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
                    }
                }
        })
        
    }
    
    func setupTableView(){
//        view.addSubview(options)
        options.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        options.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        options.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        options.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        if(indexPath.row == 0){
            cell.textLabel?.text = "Logout"
            return cell
        }
        
        cell.textLabel?.text = "Cell"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if indexPath.row == 0{
            progressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                self.progressHUD.hide()
                self.logout()
            }
        }
    }

    func logout(){
        do{
            try Auth.auth().signOut()
            let newVC = LoginVC()
            self.present(newVC, animated: true)
        }
        catch{}
    }
   
    @objc func uploadPic(){
        print("Upload pic")
    }

}