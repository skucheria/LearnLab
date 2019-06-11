//
//  Tutors.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/12/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class Tutors: UITableViewController {

    var ref : DatabaseReference?
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tutors"
        ref = Database.database().reference()
        
        tableView.register(TutorInfoCell.self, forCellReuseIdentifier: "cellId")
        
        fetchUser()
    }

    func fetchUser(){
        ref?.child("user").observeSingleEvent(of: .value
            , with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : [String:Any]]{
                    for item in dictionary{
                        let user = User()
                        user.tutor = item.value["tutor"] as? String
                        if(user.tutor == "yes"){
                            user.email = item.value["email"] as? String
                            user.name = item.value["name"] as? String
                            user.profLinik = item.value["profilePic"] as? String
                            user.id = item.key
                            user.bio = item.value["bio"] as? String
                            user.courses = item.value["classes"] as? [String]
                            self.users.append(user)
                        }
                    }
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
        })
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TutorInfoCell

        let user = self.users[indexPath.row]
        let profileImageUrl = user.profLinik
        cell.nameLabel.text = user.name
        cell.picImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        let tutorInfo = TutorInfoVC()
        tutorInfo.currentTutor = user
        self.navigationController?.pushViewController(tutorInfo, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
//
}
