//
//  SearchVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/12/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase


class SearchVC: UITableViewController, UISearchBarDelegate {
    
    lazy var searchBar:UISearchBar = UISearchBar()

    var fstore : Firestore!
    
    var filteredData = [Course]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
            searchBar.placeholder = " Search..."
            searchBar.sizeToFit()
            searchBar.isTranslucent = false
            searchBar.backgroundImage = UIImage()
            searchBar.delegate = self
            navigationItem.titleView = searchBar
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        fstore = Firestore.firestore()
        
//        pullCourses()

    }
    
    func pullCourses(_ text : String){
        fstore?.collection("courses").whereField("department", isEqualTo: text).getDocuments(completion: { (snapshot, error) in
            
            for doc in snapshot!.documents{
                if let dictionary = doc.data() as? [String:String]{
                    let course = Course()
                    course.code = dictionary["code"]
                    course.school = dictionary["school"]
                    course.department = dictionary["department"]
                    course.title = dictionary["title"]
                    self.filteredData.append(course)
                }
            }
        })
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        //query for courses and update the table view
        pullCourses(textSearched.uppercased())
        //sercah bar works
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = filteredData[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        
    }

    

}
