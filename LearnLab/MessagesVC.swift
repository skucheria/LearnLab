//
//  MessagesVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/12/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UITableViewController {

    var ref : DatabaseReference?
    
    var users = [User]()
    
    var msgs = [Message]()
    
    var allPeople : [String:Any]?
    
//    var idToUser : [String: User]?

    var msgsDict = [String:Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        ref?.child("user").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value
            , with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String : Any]{
                    self.navigationItem.title = dictionary["name"] as? String
                }
        })
        
        fetchUser()
        
        fetchMessages()
        
        tableView.register(userCellClass.self, forCellReuseIdentifier: "cellId")
//        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func fetchUser(){
     ref?.child("user").observeSingleEvent(of: .value
            , with: { (snapshot) in
                let tester = snapshot.value as? [String : [String:String] ] ?? [:]
                for item in tester{
                    let user = User()
                    if item.key != Auth.auth().currentUser?.uid{
                        user.email = item.value["email"]
                        user.name = item.value["name"]
                        user.profLinik = item.value["profilePic"]
                        user.id = item.key
                        //                    print("User: ", user.name)
                        self.users.append(user)
                    }
                }
                
                DispatchQueue.main.async { self.tableView.reloadData() }

        })
    }

    func fetchMessages(){
        ref?.child("messages").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any]{
                let msg = Message()
                msg.fromID = dictionary["fromID"] as? String
                msg.toID = dictionary["toID"] as? String
                msg.text = dictionary["text"] as? String
                msg.timestamp = dictionary["timestamp"] as? NSNumber

                if let toID = msg.toID{
                    self.msgsDict[toID] = msg
                    self.msgs = Array(self.msgsDict.values)
                }
                
//                self.msgs.append(msg)

            }
            DispatchQueue.main.async { self.tableView.reloadData() }

        }, withCancel: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.msgsDict.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! userCellClass
//
        let msg = msgs[indexPath.row]
        
        //get recipient user information
        if let toID = msg.toID{
            ref?.child("user").child(toID).observeSingleEvent(of: .value
                , with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String : Any]{
                        cell.textLabel?.text = dictionary["name"] as? String
                        let profileImageUrl = dictionary["profilePic"] as? String
                        cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
                    }
            })
        }

        cell.detailTextLabel?.text = msg.text
        
        if let seconds = msg.timestamp?.doubleValue{
            let date = NSDate(timeIntervalSince1970: seconds)
            let format = DateFormatter()
            format.dateFormat = "hh:mm a"
            cell.timeLabel.text = format.string(from: date as Date)
        }
        
//        let user = self.users[indexPath.row]
//        cell.textLabel?.text = user.name
//        cell.detailTextLabel?.text = user.email
//
//        let profileImageUrl = user.profLinik
//
//        cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let user = self.users[indexPath.row]
        
        showChatVC(user: user)
       
    }
    
    func showChatVC(user : User){
        let chatVC = ChatLogVC()
        chatVC.toUser = user
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
    
}
