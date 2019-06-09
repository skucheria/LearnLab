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

    var data = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
            searchBar.placeholder = " Course code i.e. 'CSCI, MATH' "
            searchBar.sizeToFit()
            searchBar.isTranslucent = false
            searchBar.backgroundImage = UIImage()
            searchBar.delegate = self
            navigationItem.titleView = searchBar
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(ClassInfoCell.self, forCellReuseIdentifier: "cellId")

        
        fstore = Firestore.firestore()
        
//        pullCourses()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        filteredData.removeAll()
        self.tableView.reloadData()
    }
    
    func pullCourses(_ text : String){
        fstore?.collection("courses").whereField("department", isEqualTo: text).getDocuments(completion: { (snapshot, error) in
//            if snapshot == nil{
//                self.filteredData = self.data
//            }
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
            DispatchQueue.main.async { self.tableView.reloadData() }
        })
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        if (textSearched.isEmpty){
            filteredData = data
            tableView.reloadData()
        }
        else{
            pullCourses(textSearched.uppercased())
            tableView.reloadData()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ClassInfoCell
        cell.backgroundColor = UIColor.white
        let course = filteredData[indexPath.row]
        cell.textLabel?.text = course.department! + " " + course.code!
        cell.detailTextLabel?.text = course.title!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        
    }

    

}
