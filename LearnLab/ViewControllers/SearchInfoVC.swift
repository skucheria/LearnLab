//
//  SearchInfoVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/16/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class SearchInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var users = [User]()
    
    var currentCourse : Course? {
        didSet{
            navigationItem.title = currentCourse?.title
        }
    }
    
    lazy var tableview : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupTV()
        getUsersForCouse()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        // Do any additional setup after loading the view.
        tableview.register(TutorInfoCell.self, forCellReuseIdentifier: "cellId")
    }
    
    func setupTV(){
        self.view.addSubview(tableview)
        tableview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableview.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func getUsersForCouse(){
        let ref = Database.database().reference().child("user")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String : [String : Any]]{
                for item in dictionary{
                    let courses = item.value["classes"] as? [String]
                    if courses != nil{
                        if((courses?.contains((self.currentCourse?.dbId)!))!){ //if this user is a tutor for the course, then add to users
                            let user = User()
                            user.tutor = item.value["tutor"] as? String                            
                            user.email = item.value["email"] as? String
                            user.name = item.value["name"] as? String
                            user.profLinik = item.value["profilePic"] as? String
                            user.id = item.key
                            user.bio = item.value["bio"] as? String
                            user.courses = item.value["classes"] as? [String]
                            user.rating = item.value["rating"] as? NSNumber
                            user.rate = item.value["rate"] as? String
                            user.availability = item.value["availability"] as? String
                            user.fcmToken = item.value["fcmToken"] as? String
                            user.reviews = item.value["reviews"] as? [String]
                            self.users.append(user)
                            self.users.sort(by: { (u1, u2) -> Bool in
                                return (u1.name)! < (u2.name)!
                            })
                        }
                        DispatchQueue.main.async { self.tableview.reloadData() }
                    }
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TutorInfoCell
        let user = self.users[indexPath.row]
        let profileImageUrl = user.profLinik
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.nameLabel.text = user.name
        cell.picImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //need to go to tutorInfoVC, where they can look at bio, rating, reviews, and classes and then book session
        let user = self.users[indexPath.row]
        let tutorInfo = TestScrollView()
        tutorInfo.currentTutor = user
        self.navigationController?.pushViewController(tutorInfo, animated: true)
    }

}
