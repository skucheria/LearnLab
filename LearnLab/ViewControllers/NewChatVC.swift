//
//  NewChatVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/2/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class NewChatVC: UITableViewController {

    
    var ref : DatabaseReference?
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        self.navigationItem.title = "New Message"
        self.view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        // Do any additional setup after loading the view.
        tableView.register(userCellClass.self, forCellReuseIdentifier: "cellId")

        fetchUser()
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //only fetch users who are tutors
    func fetchUser(){
        ref?.child("user").observeSingleEvent(of: .value
            , with: { (snapshot) in
                
                let tester = snapshot.value as? [String : [String:Any] ] ?? [:]
                for item in tester{
                    let user = User()
                    user.email = item.value["email"] as? String
                    user.name = item.value["name"] as? String
                    user.profLinik = item.value["profilePic"] as? String
                    user.id = item.key
                    user.bio = item.value["bio"] as? String
                    user.tutor = item.value["tutor"] as? String
                    if user.tutor == "yes"{
                        self.users.append(user)
                    }
                    
                }
                
                DispatchQueue.main.async { self.tableView.reloadData() }
                
        })
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! userCellClass
        //
        
        cell.timeLabel.text = ""
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        let profileImageUrl = user.profLinik
        
        cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
        
        return cell
    }
    
    var messagesController : MessagesVC?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatVC(user)
        }
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
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
