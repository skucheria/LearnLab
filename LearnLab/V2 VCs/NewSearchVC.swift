//
//  NewSearchVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 2/3/20.
//  Copyright © 2020 Siddharth Kucheria. All rights reserved.
//

import UIKit

class NewSearchVC: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        layoutViews()
        
        self.view.backgroundColor = .white
        self.navigationController?.title = "Search"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackOpaque
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31/255, green: 9/255, blue: 87/255, alpha: 1)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(goBack))

    }
    
    // MARK: - Tableview functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ClassInfoCell
        cell.textLabel?.text = "Class"
        return cell
    }
    
    // MARK: - UI Elements
    
    lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = " Course code i.1. 'CSCI, MATH' "
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
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
    

    let searchTV : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(ClassInfoCell.self, forCellReuseIdentifier: "cellId")
        return tv
    }()


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
