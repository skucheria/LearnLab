//
//  TutorsVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/8/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class TutorsVC: UICollectionViewController {

    var ref : DatabaseReference?
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tutors"
        
        ref = Database.database().reference()
        
        fetchUser()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    func fetchUser(){
        ref?.child("user").observeSingleEvent(of: .value
            , with: { (snapshot) in
                
                let tester = snapshot.value as? [String : [String:String] ] ?? [:]
                for item in tester{
                    let user = User()
                    user.email = item.value["email"]
                    user.name = item.value["name"]
                    user.profLinik = item.value["profilePic"]
                    user.id = item.key
                    user.tutor = item.value["tutor"]
                    if user.tutor == "yes"{
                        self.users.append(user)
                    }
                    
                    DispatchQueue.main.async { self.collectionView?.reloadData() }
                    
                }
                
                
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
//        let user = self.users[indexPath.row]
        cell.backgroundColor = .green
    
        return cell
    }

   

}
