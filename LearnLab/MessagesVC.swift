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
    
    var allPeople : [String:Any]?

    
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
//                    print(item.value["name"])
                    let user = User()
                    user.email = item.value["email"]
                    user.name = item.value["name"]
                    user.profLinik = item.value["profilePic"]
//                    print("User: ", user.name)
                    self.users.append(user)
                }
                
                DispatchQueue.main.async { self.tableView.reloadData() }

        })
        
//        print("store dictionary: ", self.allPeople)
        
//        print ("Users: ", self.users)
    
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! userCellClass
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        let profileImageUrl = user.profLinik
        
        cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatLogVC()
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    class userCellClass : UITableViewCell{
        
        override func layoutSubviews() {
            super.layoutSubviews()
            textLabel!.frame = CGRect(x: 56, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
            detailTextLabel!.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)

        }
        
        let profileImageView : UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: "person")
            imageView.layer.cornerRadius = 24
            imageView.layer.borderColor = (UIColor.red).cgColor
            imageView.layer.borderWidth = 2
            imageView.layer.masksToBounds = true
            return imageView
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: "cellId")
            addSubview(profileImageView)
            //constraints x,y,w,h
            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}
