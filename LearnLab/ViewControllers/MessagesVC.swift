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
    var currentUserInfo = User()
    var msgs = [Message]()
    var allPeople : [String:Any]?
//    var idToUser : [String: User]?
    var msgsDict = [String:Message]()
    
    lazy var newMessage : UIBarButtonItem = {
        let newMessage = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newPressed))
        newMessage.title = "New"
        return newMessage
    }()
    
    @objc func newPressed(){
        let newVC = NewChatVC()
        newVC.messagesController = self
        let navController = UINavigationController(rootViewController: newVC)
        present(navController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.navigationItem.title = "Messages"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackOpaque
        fetchUser()
        
//        fetchMessages()
        
        observeUserMessages()
        
        tableView.register(userCellClass.self, forCellReuseIdentifier: "cellId")
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 31/255, green: 9/255, blue: 87/355, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackOpaque

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func fetchUser(){
        ref?.child("user").observeSingleEvent(of: .value
            , with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : [String:Any]]{
                    for item in dictionary{
                        let user = User()
                        user.tutor = item.value["tutor"] as? String
                        user.id = item.key
                        if(user.id == Auth.auth().currentUser!.uid){
                            self.currentUserInfo.email = item.value["email"] as? String
                            self.currentUserInfo.name = item.value["name"] as? String
                            self.currentUserInfo.profLinik = item.value["profilePic"] as? String
                            self.currentUserInfo.bio = item.value["bio"] as? String
                            self.currentUserInfo.courses = item.value["classes"] as? [String]
                            self.currentUserInfo.rating = item.value["rating"] as? NSNumber
                            self.currentUserInfo.rate = item.value["rate"] as? String
                            self.currentUserInfo.availability = item.value["availability"] as? String
                        }
                    }
                }
        })
    }

    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let msgRef = Database.database().reference().child("group-messages").child(uid)
        
        msgRef.observe(.childAdded) { (snapshot) in
            let messageID = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageID)
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
                    let msg = Message()
                    msg.fromID = dictionary["fromID"] as? String
                    msg.toID = dictionary["toID"] as? String
                    msg.text = dictionary["text"] as? String
                    msg.timestamp = dictionary["timestamp"] as? NSNumber
                    
                    
                    let chatPartnerID : String?

                    if msg.fromID == Auth.auth().currentUser?.uid{
                        chatPartnerID = msg.toID
                    }
                    else{
                        chatPartnerID = msg.fromID
                    }
                    
                    if let toID = chatPartnerID{ //put in dictionary message to that person
                        self.msgsDict[toID] = msg
                        self.msgs = Array(self.msgsDict.values)
                        self.msgs.sort(by: { (m1, m2) -> Bool in
                            return (m1.timestamp?.intValue)! > (m2.timestamp?.intValue)!
                        })
                    }
                    
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleTableReload), userInfo: nil, repeats: false)
                
                }
            })
        }
    }
    var timer : Timer?
    
    @objc func handleTableReload(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchMessages(){
        ref?.child("messages").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any]{
                let msg = Message()
                msg.fromID = dictionary["fromID"] as? String
                msg.toID = dictionary["toID"] as? String
                msg.text = dictionary["text"] as? String
                msg.timestamp = dictionary["timestamp"] as? NSNumber

                if let toID = msg.toID{ //put in dictionary message to that person
                    self.msgsDict[toID] = msg
                    self.msgs = Array(self.msgsDict.values)
                    self.msgs.sort(by: { (m1, m2) -> Bool in
                        return (m1.timestamp?.intValue)! > (m2.timestamp?.intValue)!
                    })
                }
                DispatchQueue.main.async { self.tableView.reloadData() }

            }

        }, withCancel: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.msgs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! userCellClass
//
        let msg = msgs[indexPath.row]
        
        let chatPartnerID : String?
        
        if msg.fromID == Auth.auth().currentUser?.uid{
            chatPartnerID = msg.toID
        }
        else{
            chatPartnerID = msg.fromID
        }
        
        //get recipient user information
        if let id = chatPartnerID{
            ref?.child("user").child(id).observeSingleEvent(of: .value
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
            format.dateFormat = "MMM d, h:mm a"
            cell.timeLabel.text = format.string(from: date as Date)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msg = msgs[indexPath.row]
        
        let chatPartnerID : String?
        
        if msg.fromID == Auth.auth().currentUser?.uid{
            chatPartnerID = msg.toID
        }
        else{
            chatPartnerID = msg.fromID
        }
        
        let dbRef = Database.database().reference().child("user")
        
        
        dbRef.observeSingleEvent(of: .value) { (snapshot) in
            let curr = User()
            let tester = snapshot.value as? [String : [String:Any] ] ?? [:]
            for item in tester{
                if item.key == (chatPartnerID!){
                    curr.email = item.value["email"] as? String
                    curr.name = item.value["name"] as? String
                    curr.profLinik = item.value["profilePic"] as? String
                    curr.id = chatPartnerID
                    curr.fcmToken = item.value["fcmToken"] as? String
                    self.showChatVC(curr)
                }
            }
        }
    }
    
    func showChatVC(_ user : User){
//        present(navController, animated: true, completion: nil)
        let chatVC = ChatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: chatVC)
        chatVC.toUser = user
        chatVC.curr = currentUserInfo
        self.navigationController?.present(navController, animated: true, completion: nil)
//        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
    
}
