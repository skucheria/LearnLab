//
//  SearchVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/12/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase


class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    lazy var searchBar:UISearchBar = UISearchBar()

    var fstore : Firestore!
    
    var filteredData = [Course]()

    var data = [Course]()
    
    let searchTV : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let getStartedLabel : UILabel = {
        let label = UILabel()
        label.text = "Get started by searching for a class you need help in!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        return label
    }()
    
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

        searchTV.delegate = self
        searchTV.dataSource = self
        searchTV.register(ClassInfoCell.self, forCellReuseIdentifier: "cellId")

        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 255/255, green: 124/255, blue: 89/355, alpha: 1)
//        self.view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
//        tabBarController?.tabBar.barTintColor = UIColor(displayP3Red: 202/255, green: 235/255, blue: 242/255, alpha: 1)
        self.view.backgroundColor = .white
        setupTV()
        self.searchTV.isHidden = true
        addGetStartedLabel()
        fstore = Firestore.firestore()
    }
    
    func addGetStartedLabel(){
        self.view.addSubview(getStartedLabel)
        getStartedLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        getStartedLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        getStartedLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    func setupTV(){
        self.view.addSubview(searchTV)
        searchTV.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        searchTV.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchTV.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        searchTV.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.searchBar.endEditing(true)
        if self.searchBar.text!.isEmpty{
            self.searchTV.isHidden = true
            addGetStartedLabel()
            self.searchBar.text = ""
        }
//        filteredData = data
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
                    course.dbId = doc.documentID
                    self.filteredData.append(course)
                }
            }
            self.filteredData.sort(by: { (m1, m2) -> Bool in
                return (m1.code)! < (m2.code)!
            })
            DispatchQueue.main.async { self.searchTV.reloadData() }
        })
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        self.searchTV.isHidden = false
        self.getStartedLabel.removeFromSuperview()
        if (textSearched.isEmpty){
            filteredData = data
            searchTV.reloadData()
        }
        else{
            pullCourses(textSearched.uppercased())
            searchTV.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        searchBar.endEditing(true)
        // Hide the cancel button
        searchBar.showsCancelButton = true
        filteredData.removeAll()
        self.searchTV.reloadData()
        self.searchTV.isHidden = true
        addGetStartedLabel()
        // You could also change the position, frame etc of the searchBar
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count

    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ClassInfoCell
//        cell.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        let course = filteredData[indexPath.row]  // BUG HERE
        cell.textLabel?.text = course.department! + " " + course.code!
        cell.detailTextLabel?.text = course.title!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        //pull up a tableview of tutors for that subject
        let course = self.filteredData[indexPath.row]
        let searchInfo = SearchInfoVC()
        searchInfo.currentCourse = course
        self.navigationController?.pushViewController(searchInfo, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
}
