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
            searchBar.showsCancelButton = true
            navigationItem.titleView = searchBar
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        tableView.register(ClassInfoCell.self, forCellReuseIdentifier: "cellId")

        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 254/255, green: 74/255, blue: 26/355, alpha: 1)
        self.view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        tabBarController?.tabBar.barTintColor = UIColor(displayP3Red: 202/255, green: 235/255, blue: 242/255, alpha: 1)
        
        fstore = Firestore.firestore()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        filteredData.removeAll()
        self.tableView.reloadData()
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
            self.filteredData.sort(by: { (m1, m2) -> Bool in
                return (m1.code)! < (m2.code)!
            })
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = false
        // You could also change the position, frame etc of the searchBar
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
        cell.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        let course = filteredData[indexPath.row]
        cell.textLabel?.text = course.department! + " " + course.code!
        cell.detailTextLabel?.text = course.title!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    
}
