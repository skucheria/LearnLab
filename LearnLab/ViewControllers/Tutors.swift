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
    var fstore : Firestore!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tutors"
        ref = Database.database().reference()
        self.view.backgroundColor = UIColor(displayP3Red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        tabBarController?.tabBar.barTintColor = UIColor(displayP3Red: 202/255, green: 235/255, blue: 242/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 254/255, green: 74/255, blue: 26/355, alpha: 1)

        tableView.register(TutorInfoCell.self, forCellReuseIdentifier: "cellId")

        fstore = Firestore.firestore()

        
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
                            user.rating = item.value["rating"] as? NSNumber
                            self.users.append(user)
                        }
                    }
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
                //maybe add code here for pulling the courses too? jsut so the label stuff isn't all messed up
        })
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TutorInfoCell

        let user = self.users[indexPath.section]
        let profileImageUrl = user.profLinik
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.nameLabel.text = user.name
        cell.picImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
        if (user.rating == nil){
            cell.ratingLabel.text = "No Ratings"
        }
        else{
            cell.ratingLabel.text = (user.rating?.stringValue)! + " ⭐️ "
        }
        var coursesLabel = String()
        var titles = [String]()
        var counter = 0
        cell.classLabel.text?.removeAll()
        for c in user.courses!{
            fstore?.collection("courses").document(c).getDocument(completion: { (snapshot, error) in
                if let dict = snapshot?.data() as? [String:String]{
                    counter+=1
                    coursesLabel += (dict["title"]! + " ")
                    titles.append(dict["title"]!)
                    (cell.classLabel.text)! += ((dict["department"]! + dict["code"]!))
                    if(counter != user.courses?.count){
                        (cell.classLabel.text)! += ", "
                    }
                }
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Put your code which should be executed with a delay here
//            cell.classLabel.text = coursesLabel
        })

//        cell.classLabel.text = coursesLabel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.section]
        let tutorInfo = TestScrollView()
        tutorInfo.currentTutor = user
//        let test = TestScrollView()
        self.navigationController?.pushViewController(tutorInfo, animated: true)
        
    }
    
    /*
     override fun tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.section]
        let tutorInfo = TestScrollView()
        tutorInfo.currentTutor = user
     self.navigationController?.present(tutorInfo, animated: true, completion: nil)
        let dbReference = Database.database().reference.child("user").child(Auth.auth().currentUser!.uid)
     
 
    */
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "    "
        return label
    }
//
}
