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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        

//        if let profileImageUrl = user.profLinik{
//            let url = URL(string: profileImageUrl)
//            print("URL FOR PIC ", url)
//
//
//            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
//                if error != nil{
//                    print(error)
//                    return
//                }
//
//                DispatchQueue.main.async { cell.imageView?.image = UIImage(data: data!)
//                    cell.imageView?.contentMode = .scaleAspectFill
//                }
//
//
//            }).resume()
//
//        }
        
        return cell
    }
    
    class userCellClass : UITableViewCell{
        
        let profileImageView : UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: "person")
            return imageView
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: "cellId")
            addSubview(profileImageView)
            //constraints x,y,w,h
            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}
